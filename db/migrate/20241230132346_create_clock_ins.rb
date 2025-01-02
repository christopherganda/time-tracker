class CreateClockIns < ActiveRecord::Migration[7.0]
  def up
    create_table :clock_ins do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clocked_in_at, null: false
      t.boolean :is_clocked_out, default: false, null: false
    end
    add_index :clock_ins, [:user_id, :clocked_in_at]
  end

  def down
    drop_table :clock_ins
  end
end
