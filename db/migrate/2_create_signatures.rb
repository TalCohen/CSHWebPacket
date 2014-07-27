class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.references :freshman, index: true
      t.references :signer, polymorphic: true, index: true

      t.timestamps
    end
  end
end
