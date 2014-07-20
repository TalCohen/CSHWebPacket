class AddActiveToFreshmen < ActiveRecord::Migration
  def change
    add_column :freshmen, :active, :boolean,
  end
end
