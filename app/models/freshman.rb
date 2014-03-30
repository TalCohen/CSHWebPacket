class Freshman < ActiveRecord::Base
  has_many :signatures, dependent: :destroy
  
  def to_s
    return "#{freshman.name} - #{freshman.username}"
  end
end
