class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.integer :freshman_id
      t.string :upperclassman_uuid
      t.string :upperclassman_name
      t.boolean :is_signed, default: false

      t.timestamps
    end
  end
end
