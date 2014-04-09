# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require_relative 'packet_ldap'

def create_upperclassmen
  # Gets an array of the upperclassmen
  packet_ldap =  PacketLdap::Ldap.new
  upperclassmen =  packet_ldap.find_upperclassmen

  # Creates the upperclassmen objects
  puts("\nCreating Upperclassmen...")
  upperclassmen.each do |upper|
    u = Upperclassman.create(name: "#{upper.givenName[0]} #{upper.sn[0]}",
                             uuid: "#{upper.entryuuid[0]}")
    puts("Upperclassman - #{u.name}, #{u.uuid}")
  end
  puts("Upperclassmen Length - #{upperclassmen.length}")
end

def create_freshmen
  # Creates some dummy freshmen names
  freshmen = []
  f = File.read("/var/www/priv/packet/db/freshmen.txt")
  f.each_line do |line|
    freshmen.push(line.chomp)
  end

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

create_upperclassmen
create_freshmen


