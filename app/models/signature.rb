class Signature < ActiveRecord::Base
    belongs_to :freshman

    def to_s
      return "#{is_signed} -> #{freshman.name}"
    end

end
