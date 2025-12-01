class CreateJoggingEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :jogging_entries do |t|
      t.date :date
      t.float :distance
      t.integer :duration
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
