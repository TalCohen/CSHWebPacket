class Freshman < ActiveRecord::Base
  has_many :signatures, as: :signer, dependent: :destroy
  has_secure_password
  validates_presence_of :password, :on => :create

  def create_freshman(fresh, password, doing_packet, on_packet)
    # Creates a freshman based on an ldap entry
    #
    # fresh - An ldap entry for the freshman
    self.name = fresh
    self.password = password
    self.password_confirmation = password
    self.doing_packet = doing_packet
    self.on_packet = on_packet
    self.save
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
    upperclassmen_signatures = Signature.where(freshman_id: self.id, signer_type: "Upperclassman").order(updated_at: :asc)

    upperclassmen_signatures.each do |s|
      u = s.signer
      index = alumni_signatures.index(nil)
      if index and u.alumni
        # Replace nil with Alumni.name
        alumni_signatures[index] = u
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
