class CreateFreshmen < ActiveRecord::Migration
  def change
    create_table :freshmen do |t|
      t.string :name
      t.string :password_digest
      t.boolean :doing_packet
      t.boolean :on_packet
      t.text :info_directorships, default: "Evaluations: \r\n\r\n\r\n\r\n"\
        "Financial: \r\n\r\n\r\n\r\n"\
        "History: \r\n\r\n\r\n\r\n"\
        "House Improvements: \r\n\r\n\r\n\r\n"\
        "Operational Communications: \r\n\r\n\r\n\r\n"\
        "Research & Development: \r\n\r\n\r\n\r\n"\
        "Social: \r\n\r\n\r\n\r\n"
      t.text :info_events, default: "1. \r\n"\
        "2. \r\n"\
        "3. \r\n"\
        "4. \r\n"\
        "5. \r\n"\
        "6. \r\n"\
        "7. \r\n"
      t.text :info_achievements, default: "1. \r\n"\
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
