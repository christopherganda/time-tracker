class AddIndexToSleepRecordsOnUserIdAndClockedInAt < ActiveRecord::Migration[7.0]
  def up
    add_index :sleep_records, [:user_id, :clocked_in_at], name: 'index_sleep_records_on_user_id_and_clocked_in_at'
  end

  def down
    remove_index :sleep_records, name: 'index_sleep_records_on_user_id_and_clocked_in_at'
  end
end
