class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.integer :freshman_id
      t.string :upperclassman_uuid
      t.boolean :is_signed

      t.timestamps
    end
  end
end
