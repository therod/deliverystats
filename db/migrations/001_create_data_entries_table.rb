require_relative '../../environment'

class CreateDataEntriesTable < ActiveRecord::Migration
  def up
    create_tabe :data_entries do |t|
      # Define the fields
    end
  end

  def down
    drop_table :data_entries
  end
end
