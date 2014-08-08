# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require_relative 'packet_ldap'

def create_upperclassmen
  # Gets an array of the upperclassmen
  packet_ldap =  PacketLdap::Ldap.new
  upperclassmen =  packet_ldap.find_upperclassmen

  admin_uuid = File.read("/var/www/priv/packet/db/admin.txt").chomp

  # Creates the upperclassmen objects
  puts("\nCreating Upperclassmen...")
  upperclassmen.each do |upper|
    admin = upper.entryuuid[0] == admin_uuid
    u = Upperclassman.new
    u.create_upperclassman(upper, admin)
    puts("Upperclassman - #{u.name}, #{u.uuid}")
  end
  puts("Upperclassmen Length - #{upperclassmen.length}")
end

def create_freshmen
  # Get the freshmen names from the file
  freshmen = []
  f = File.read("/var/www/priv/packet/db/freshmen.txt")
  #f = File.read("/var/www/priv/packet/db/julien.txt")
  f.each_line do |line|
    freshmen.push(line.chomp)
  end

  # Creates the freshmen objects
  puts("\nCreating Freshmen")
  freshmen.each do |fresh|
    puts("Freshman - #{fresh}")
    f = Freshman.new
    f.create_freshman(fresh, true, true)
  end
end

create_upperclassmen
create_freshmen
Signature.create(freshman_id: Freshman.first.id, signer: Upperclassman.find(2))
