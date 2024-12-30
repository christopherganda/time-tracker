class CreateSleepRecords < ActiveRecord::Migration[7.0]
  def up
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :clock_in, null: false, foreign_key: true
      t.datetime :clocked_in_at, null: false
      t.datetime :clocked_out_at, null: false
    end
  end

  def down
    drop_table :sleep_records
  end
end
