class CreateUpperclassmen < ActiveRecord::Migration
  def change
    create_table :upperclassmen do |t|
      t.string :name
      t.string :uuid
      t.boolean :admin, default: false
      t.boolean :alumni, deafult: false
      t.boolean :talpacket_theme, default: false

      t.timestamps
    end
  end
end
