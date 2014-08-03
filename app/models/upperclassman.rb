class Upperclassman < ActiveRecord::Base
  has_many :signatures, as: :signer, dependent: :destroy

  def create_upperclassman(upper, alumni=false)
    # Creates an upperclassman based on an ldap entry
    #
    # upper - An ldap entry for the upperclassman
    self.name = "#{upper.givenName[0]} #{upper.sn[0]}"
    self.uuid = "#{upper.entryuuid[0]}"
    self.alumni = alumni
    self.save
  end

  def <=>(other)
    # Compare upperclassmen aplhabetically
    #
    # other - The other upperclassman to compare to
    self.name.downcase <=> other.name.downcase
  end

  def get_signatures
    # Gets a list of sorted signatures, based on is_signed (true > false)
    # and then aphabetically
    #
    # returns - The sorted list
    signatures = self.signatures
    return signatures.sort {|a,b| [b,Freshman.find(a.freshman_id)] <=> [a,Freshman.find(b.freshman_id)]}
  end

end
