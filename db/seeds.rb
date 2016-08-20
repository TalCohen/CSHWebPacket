# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require_relative 'packet_ldap'
include Haddock

def create_upperclassmen
  # Gets an array of the upperclassmen
  packet_ldap =  PacketLdap::Ldap.new
  upperclassmen =  packet_ldap.find_upperclassmen
  eval_director = packet_ldap.find_eval_director

  eval_uuid = eval_director[0].entryuuid[0] if eval_director
  puts eval_uuid
  admin_uuid = File.read("db/admin.txt").chomp

  # Creates the upperclassmen objects
  puts("\nCreating Upperclassmen...")
  upperclassmen.each do |upper|
    admin = upper.entryuuid[0] == admin_uuid || upper.entryuuid[0] == eval_uuid
    u = Upperclassman.new
    u.create_upperclassman(upper, admin)
    print "Upperclassman - #{u.name}, #{u.uuid}"
    if admin
      puts " - Admin"
    else
      puts ""
    end
  end
  puts("Upperclassmen Length - #{upperclassmen.length}")
end

def create_freshmen
  # Get the freshmen names from the file and create the freshmen objects
  onfloor = File.read("db/onfloor.txt")
  offfloor = File.read("db/offfloor.txt")
  puts("\nCreating Freshmen")
  onfloor.each_line do |line|
    fresh = line.chomp
    password = Password.generate
    f = Freshman.new
    f.create_freshman(fresh, password, true, true)
    puts("Freshman - #{fresh}")

    File.open("db/freshmen.txt", 'a') do |file|
      file.puts("#{fresh} - #{password}")
    end
  end

  offfloor.each_line do |line|
    fresh = line.chomp
    password = Password.generate
    f = Freshman.new
    f.create_freshman(fresh, password, true, false)
    puts ("Freshman - #{fresh}")

    File.open("db/freshmen.txt", 'a') do |file|
      file.puts("#{fresh} - #{password}")
    end
  end
end

create_upperclassmen
create_freshmen
