class CreateFreshmen < ActiveRecord::Migration
  def change
    create_table :freshmen do |t|
      t.string :name
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end