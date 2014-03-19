# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require_relative 'ldap'

module PacketLdap

  # Gets an array of the upperclassmen
  packet_ldap =  Ldap.new
  uppers =  packet_ldap.find_upperclassmen

  uppers.each do |u|
    puts("#{u.givenName[0]} #{u.sn[0]}")
  end
  puts("#{uppers.length}")

  # Creates some dummy freshmen with upperclassmen in their signatures
  freshmen = [["Chase Berry", "cberry", "chasepass"], \
                ["Michael Lynch", "mlynch", "michaelpass"], \
                ["Aidan McInerny", "amcinerny", "aidanpass"], \
                ["Eric Knapik", "eknapik", "epass"], \
                ["Harlan Haskins", "hhaskins", "harlanpass"]]  
  freshmen.each do |fresh|
    f = Freshman.create(name: fresh[0], username: fresh[1], password: fresh[2])
    uppers.each do|u|
      f.signatures.create(upperclassman_name: "#{u.givenName[0]} #{u.sn[0]}")
    end
  end

end



#upperclassmen = Upperclassman.all

#freshmen = Freshman.all
#freshmen.each do |f|
