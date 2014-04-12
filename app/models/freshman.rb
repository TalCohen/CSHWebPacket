class Freshman < ActiveRecord::Base
  has_many :signatures, dependent: :destroy

  def <=>(other)
    # Compare freshmen alphabetically
    (self.name.downcase <=> other.name.downcase)
  end

  def get_signatures
    # Gets a list of sorted signatures, based on is_signed (true > false)
    # and then aphabetically
    signatures = self.signatures
    return signatures.sort {|a,b| [b,Upperclassman.find(a.upperclassman_id)] <=> [a,Upperclassman.find(b.upperclassman_id)]}
  end

end
