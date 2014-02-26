class Freshman < ActiveRecord::Base
    has_many :signatures, dependent: :destroy
end
