class CreateFreshmen < ActiveRecord::Migration
  def change
    create_table :freshmen do |t|
      t.string :name
      t.binary :password_digest
      t.boolean :doing_packet
      t.boolean :on_packet
      t.date :start_date, default: Date.today.in_time_zone
      t.text :info_directorships
      t.text :info_events
      t.text :info_achievements
      t.timestamps
    end
  end
end
