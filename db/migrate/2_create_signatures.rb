class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.integer :freshman_id
      t.integer :upperclassman_id
      t.boolean :is_signed, default: false

      t.timestamps
    end
  end
end
