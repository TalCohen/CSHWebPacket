class Upperclassman < ActiveRecord::Base
  has_many :signatures, dependent: :destroy

  def create_upperclassman(upper, alumni=false)
    # Creates an upperclassman based on an ldap entry
    #
    # upper - An ldap entry for the upperclassman
    self.name = "#{upper.givenName[0]} #{upper.sn[0]}"
    self.uuid = "#{upper.entryuuid[0]}"
    self.alumni = alumni
    self.save

    # Iterate through all freshmen and add a signature object
    if alumni
      Freshman.all.each do |f|
        Signature.create(freshman_id: f.id, upperclassman_id: self.id)
      end
    end
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
