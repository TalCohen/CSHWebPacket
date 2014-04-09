class Signature < ActiveRecord::Base
    belongs_to :freshman
    belongs_to :upperclassman

    def to_s
      return "id: #{id}, f_id: #{freshman_id}, u_id: #{upperclassman_id}, is_signed: #{is_signed}"
    end

    def <=>(other)
       # Compare signatures based on is_signed then id (true > false)
      (self.is_signed == other.is_signed) ? ((self.id > other.id) ? -1 : 1) : (self.is_signed ? 1 : -1)
    end

end
