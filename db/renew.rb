require_relative 'packet_ldap'

def renew
  Signature.destroy_all
  Upperclassman.destroy_all

  create_upperclassmen
  update_onfloor_freshmen
end

def create_upperclassmen
  # Gets an array of the upperclassmen
  packet_ldap =  PacketLdap::Ldap.new
  upperclassmen =  packet_ldap.find_upperclassmen

  admin_uuid = File.read("db/admin.txt").chomp

  # Creates the upperclassmen objects
  puts("\nCreating Upperclassmen...")
  upperclassmen.each do |upper|
    admin = upper.entryuuid[0] == admin_uuid
    u = Upperclassman.new
    u.create_upperclassman(upper, admin)
    puts("Upperclassman - #{u.name}, #{u.uuid}")
  end
  puts("Upperclassmen Length - #{upperclassmen.length}")
  puts("")
end

def update_onfloor_freshmen
  Freshman.where(on_packet: true).each do |o|
    o.update_attributes(on_packet: false)
    puts("Freshman - #{o.name} => off-floor")
  end
  puts("")

  lines = 0
  updated = 0
  File.read("db/onfloor.txt").each_line do |line|
    lines += 1
    name = line.chomp
    fresh = Freshman.find_by_name(name)
    if fresh
      fresh.update_attributes(on_packet: true)
      updated += 1
      puts("Freshman - #{name} => on-floor")
    else
      puts("Freshman - #{name} was not found")
    end
  end
  puts("Updated #{updated}/#{lines} freshmen to on-floor\n")
end

renew
