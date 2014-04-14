class Freshman < ActiveRecord::Base
  has_many :signatures, dependent: :destroy

  def create_freshman(fresh)
    # Creates a freshman based on an ldap entry
    #
    # fresh - An ldap entry for the freshman
    self.name = fresh
    self.save
    # Iterate through all upperclassmen and create a signature object with them
    Upperclassman.all.each do |u|
      Signature.create(freshman_id: self.id, upperclassman_id: u.id)
    end
  end

  def <=>(other)
    # Compare freshmen alphabetically
    # 
    # other - The other freshman to compare to
    (self.name.downcase <=> other.name.downcase)
  end

  def get_signatures
    # Gets a list of sorted signatures, based on is_signed (true > false)
    # and then aphabetically
    #
    # returns - The sorted list
    signatures = self.signatures
    return signatures.sort {|a,b| [b,Upperclassman.find(a.upperclassman_id)] <=> [a,Upperclassman.find(b.upperclassman_id)]}
  end

end
