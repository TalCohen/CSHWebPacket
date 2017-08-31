require 'net-ldap'

LDAP_USER_BASE   = 'ou=Users,dc=csh,dc=rit,dc=edu'.freeze
LDAP_GROUPS_BASE = 'ou=Groups,dc=csh,dc=rit,dc=edu'.freeze
LDAP_EVAL_BASE   = 'cn=Evaulations,ou=Committees,dc=csh,dc=rit,dc=edu'.freeze
LDAP_EBOARD_CN   = 'eboard'.freeze
LDAP_INTRO_CN    = 'intromembers'.freeze 
LDAP_FAILED_CN    = 'failed'.freeze 
module PacketLdap
    class Ldap
        include Net

        EXCEPTIONS = [OpenSSL::SSL::SSLError, Net::LDAP::LdapError,Errno::ETIMEDOUT ]

        def initialize()
            host     = 'ldap.csh.rit.edu'
            port     = 636
            username = 'cn=packet,ou=Apps,dc=csh,dc=rit,dc=edu'
            password = IO.read('db-key').chomp 
            @ldap = LDAP.new({
                :host => host,
                :port => port,
                :auth => {
                    :method   => :simple,
                    :username => username,
                    :password => password
                },
                :encryption => :simple_tls
            })
            begin
                unless @ldap.bind
                    @ldap = nil
                    fail 'Could not connect to ldap'
                end
            rescue *EXCEPTIONS
                puts('failed ldap bind. sleeping and trying again')
                sleep(5)
                retry
            end
        end

        def info_for_ibutton(ibutton)
            filter = LDAP::Filter.eq('ibutton', ibutton)
            perform_info_search(filter)
        end

        def info_for_username(username)
            filter = LDAP::Filter.eq('uid', username)
            perform_info_search(filter)
        end

        def info_for_uuid(uuid)
            filter = LDAP::Filter.eq('entryUUID', uuid)
            perform_info_search(filter)
        end

        def validate_user_credentials(username, password)
            host     = 'ldap.csh.rit.edu'
            port     = 636
            conn = LDAP.new({
                :host => host,
                :port => port,
                :auth => {
                    :method   => :simple,
                    :username => "uid=#{username}, #{LDAP_USER_BASE}",
                    :password => password
                },
                :encryption => :simple_tls
            })
            p conn.get_operation_result
            conn.bind
        end

        def find_onfloor
          onfloor = LDAP::Filter.eq('roomNumber', '*')
        end

        def find_group(group_cn)
            group = @ldap.search({
                :base       => LDAP_GROUPS_BASE,
                :filter     => LDAP::Filter.join(LDAP::Filter.eq('objectClass', \
                                'groupOfNames'), LDAP::Filter.eq('cn', group_cn)),
            })
            group = group[0].member # gets list of the group members
            
            first = group[0].split(',')[0].split('=')[1] # gets the first uid
            filter = LDAP::Filter.eq('uid', "#{first}") # initializes filter
            group.shift # shifts group one element

            group.each do |g| 
                uid = g.split(',')[0].split('=')[1] # uid of the group member
                # or do through regexp
                
                f = LDAP::Filter.eq('uid', "#{uid}")
                filter = LDAP::Filter.intersect(filter, f) # will be all of the group members
                                                           # added one by one
            end

            return filter
        end

        def find_intromembers
            intro = find_group(LDAP_INTRO_CN)         
            result = @ldap.search({
                :base       => LDAP_USER_BASE,
                :filter     => intro,
                :attributes => ["*", "+"]
            })
            return result
        end

        def find_upperclassmen
            onfloor = find_onfloor
            eboard = find_group(LDAP_EBOARD_CN)
            intro = find_group(LDAP_INTRO_CN)
            failed = find_group(LDAP_FAILED_CN)

            filter = LDAP::Filter.intersect(onfloor, eboard) # filter is onfloor and eboard

            # These lines should only be used for the semester renew!
            intro = LDAP::Filter.join(intro, filter) # intro is just the ones in filter
            filter = LDAP::Filter.join(~intro, filter) # filter is onfloor and eboard - intro members

            failed = LDAP::Filter.join(failed, filter) # failed is just the ones in filter
            filter = LDAP::Filter.join(~failed, filter) # filter is onfloor and eboard - (intro members and failed members)
            result = @ldap.search({
                :base       => LDAP_USER_BASE,
                :filter     => filter,
                :attributes => ["*", "+"]
            })
            return result
        end

        def find_eval_director
          filter = LDAP::Filter.eq('uid', '*')
          result = @ldap.search({
                :base       => LDAP_EVAL_BASE,
                :attributes => ['head']
            })
          if result.length
            uid = result[0].head[0].split(',')[0].split('=')[1]
            find_by_username(uid) 
          end
        end

        def find_by_username(username)
            filter = LDAP::Filter.eq('uid', username)
            result = @ldap.search({
                :base       => LDAP_USER_BASE,
                :filter     => filter,
                :attributes => ["*", "+"]
            })
            return result
        end


        private
            
        def perform_info_search(filter)
            begin
                result = @ldap.search({
                    :base       => LDAP_USER_BASE,
                    :filter     => filter,
                    :attributes => ['ibutton', 'entryUUID', 'cn', 'dn'],
                    :size       => 1
                }).first
            rescue *EXCEPTIONS
                puts('perform info search failed')
                return nil
            end

            return nil unless result

            ibutton = result[:ibutton].first
            uuid    = result[:entryUUID].first
            cn     = result[:cn].first
            dn     = result[:dn].first
            begin
                result = @ldap.search({
                    :base       => LDAP_GROUPS_BASE,
                    :filter     => LDAP::Filter.join(LDAP::Filter.eq('objectClass', 'groupOfNames'), LDAP::Filter.eq('cn', LDAP_EBOARD_CN)),
                    :attributes => ['member'],
                    :size       => 1
                }).first
            rescue *EXCEPTIONS
                sleep(5)
                puts('perform info search failed, sleeping and trying again.')
                retry
            end

            admin = result[:member].include?(dn)

            {:ibutton => ibutton, :uuid => uuid, :name => cn, :admin => admin}
        end
    end
end
