class Freshman < ActiveRecord::Base
  has_many :signatures, dependent: :destroy

  def create_freshman(fresh)
    # Creates a freshman based on an ldap entry
    #
    # fresh - An ldap entry for the freshman
    self.name = fresh
    self.password = fresh
    self.active = true
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
    signatures = Signature.includes(:upperclassman).where(freshman_id: self.id, "upperclassmen.alumni" => false)
    return signatures.sort {|a,b| [b,Upperclassman.find(a.upperclassman_id)] <=> [a,Upperclassman.find(b.upperclassman_id)]}
  end

  def get_alumni_signatures
    # Gets the alumni signatures of the freshman's packet
    #
    # returns - an array of alumni signatures

    # Iterate through alumni signatures and add to alumni list
    alumni_signatures = Array.new(15)

    # Gets the alumni signatures ordered by oldest signature to newest
    alumni = Signature.includes(:upperclassman).where(freshman_id: self.id,
      "upperclassmen.alumni" => true, is_signed: true).order(updated_at: :asc)
    alumni.each do |a|
      index = alumni_signatures.index(nil)
      if index
        # Replace nil with [Alumni, Signature]
        alumni_signatures[index] =
              [Upperclassman.find(a.upperclassman_id).name, a]
      end
    end

    return alumni_signatures
  end

  def get_alumni_signatures_count
    # Gets the number of alumni signatures of the freshman's packet
    #
    # returns - the number of alumni signatures

    return get_alumni_signatures.select { |s| s != nil}.length
  end

end
