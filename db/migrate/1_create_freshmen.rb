class CreateFreshmen < ActiveRecord::Migration
  def change
    create_table :freshmen do |t|
      t.string :name
      t.string :password_digest
      t.boolean :active, default: true
      t.boolean :on_packet

      t.timestamps
    end
  end
end
