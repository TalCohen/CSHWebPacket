class CreateUpperclassmen < ActiveRecord::Migration
  def change
    create_table :upperclassmen do |t|
      t.string :name
      t.string :uuid

      t.timestamps
    end
  end
end
