class Signature < ActiveRecord::Base
    belongs_to :freshman
    belongs_to :signer, polymorphic: true
    validates :freshman, uniqueness: { scope: :signer }
end
