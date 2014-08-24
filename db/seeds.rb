# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require_relative 'packet_ldap'
include Haddock

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
  # Get the freshmen names from the file and create the freshmen objects
  onfloor = File.read("/var/www/priv/packet/db/onfloor.txt")
  offfloor = File.read("/var/www/priv/packet/db/offfloor.txt")
  puts("\nCreating Freshmen")
  onfloor.each_line do |line|
    fresh = line.chomp
    password = Password.generate
    f = Freshman.new
    f.create_freshman(fresh, password, true, true)
    puts("Freshman - #{fresh}")

    File.open("/var/www/priv/packet/db/freshmen.txt", 'a') do |file|
      file.puts("#{fresh} - #{password}")
    end
  end

  offfloor.each_line do |line|
    fresh = line.chomp
    password = Password.generate
    f = Freshman.new
    f.create_freshman(fresh, password, true, false)
    puts ("Freshman - #{fresh}")

    File.open("/var/www/priv/packet/db/freshmen.txt", 'a') do |file|
      file.puts("#{fresh} - #{password}")
    end
  end
end

create_upperclassmen
create_freshmen
