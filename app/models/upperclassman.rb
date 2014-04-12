class Upperclassman < ActiveRecord::Base
  has_many :signatures, dependent: :destroy

  def <=>(other)
    # Compare upperclassmen aplhabetically
    self.name.downcase <=> other.name.downcase
  end

  def get_signatures
    # Gets a list of sorted signatures, based on is_signed (true > false)
    # and then aphabetically
    signatures = self.signatures
    return signatures.sort {|a,b| [b,Freshman.find(a.freshman_id)] <=> [a,Freshman.find(b.freshman_id)]}
  end

end
