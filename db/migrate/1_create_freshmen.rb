class CreateFreshmen < ActiveRecord::Migration
  def change
    create_table :freshmen do |t|
      t.string :name
      t.binary :password_digest
      t.boolean :doing_packet
      t.boolean :on_packet
      t.date :start_date, default: Date.today.in_time_zone
      t.string :info_directorships, default: "Evaluations: \r\n\r\n\r\n\r\n"\
        "Financial: \r\n\r\n\r\n\r\n"\
        "History: \r\n\r\n\r\n\r\n"\
        "House Improvements: \r\n\r\n\r\n\r\n"\
        "Operational Communications: \r\n\r\n\r\n\r\n"\
        "Research & Development: \r\n\r\n\r\n\r\n"\
        "Social: \r\n\r\n\r\n\r\n"
      t.string :info_events, default: "1. \r\n"\
        "2. \r\n"\
        "3. \r\n"\
        "4. \r\n"\
        "5. \r\n"\
        "6. \r\n"\
        "7. \r\n"
      t.string :info_achievements, default: "1. \r\n"\
        "2. \r\n"\
        "3. \r\n"\
        "4. \r\n"\
        "5. \r\n"\
        "6. \r\n"\
        "7. \r\n"
      t.timestamps
    end
  end
end
