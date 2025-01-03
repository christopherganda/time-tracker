class AddIndexClockInsOnIsClockedOutAndUserId < ActiveRecord::Migration[7.0]
  def up
    add_index :clock_ins, [:user_id, :is_clocked_out], name: 'index_clock_ins_on_user_id_and_is_clocked_out'
    remove_index :clock_ins, [:user_id, :clocked_in_at]
  end

  def down
    remove_index :clock_ins, name: 'index_clock_ins_on_user_id_and_is_clocked_out'
    add_index :clock_ins, [:user_id, :clocked_in_at]
  end
end
