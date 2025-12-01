class AddTimeToJoggingEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :jogging_entries, :time, :integer
  end
end
