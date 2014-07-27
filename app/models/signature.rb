class Signature < ActiveRecord::Base
    belongs_to :freshman
    belongs_to :signer, polymorphic: true
end
