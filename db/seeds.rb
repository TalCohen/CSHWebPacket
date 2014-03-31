# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require_relative 'packet_ldap'

module PacketLdap

  # Gets an array of the upperclassmen
  packet_ldap =  Ldap.new
  upperclassmen =  packet_ldap.find_upperclassmen


  # Creates some dummy freshmen names
  freshmen = ["f_chase_berry", "f_michael_lynch", "f_aidan_mcinerny", \
               "f_eric_knapik", "f_harlan_haskins", "f_andrew_jeddeloh", \
               "f_madison_flaherty", "f_tish_khan", "f_ben_grawi", \
               "f_john_king", "f_paul_lane", "f_adrian_svenson", \
               "f_drew_gottlieb", "f_josh_milas", "f_jamie_yates", \
               "f_mihir_singh", "f_oliver_barnum", "f_susan_lunn", \
               "f_victoria_weaver", "f_will_lueking"] 


  # Creates the upperclassmen objects
  puts("\nCreating Upperclassmen...")
  upperclassmen.each do |upper|
    u = Upperclassman.create(name: "#{upper.givenName[0]} #{upper.sn[0]}",
                             uuid: "#{upper.entryuuid[0]}")
    puts("Upperclassman - #{u.name}, #{u.uuid}")
  end

  puts("Upperclassmen Length - #{upperclassmen.length}")


  # Creates the freshmen and signatures objects
  puts("\nCreating Freshmen and Signatures...")
  freshmen.each do |fresh|
    f = Freshman.create(name: fresh)
    puts("Freshman - #{f.name}")

    Upperclassman.all.each do |u|
      s = Signature.create(freshman_id: f.id, upperclassman_id: u.id)
    end
    
  end

end
