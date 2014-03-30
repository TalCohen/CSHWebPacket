class Signature < ActiveRecord::Base
    belongs_to :freshman
    belongs_to :upperclassman

    def to_s
      return "#{is_signed}"
    end
      

end
