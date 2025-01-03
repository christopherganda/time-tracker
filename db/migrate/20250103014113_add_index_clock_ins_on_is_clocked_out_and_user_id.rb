class AddIndexClockInsOnIsClockedOutAndUserId < ActiveRecord::Migration[7.0]
  def up
    add_index :clock_ins, [:is_clocked_out, :user_id], name: 'index_clock_ins_on_is_clocked_out_and_user_id'
    remove_index :clock_ins, [:user_id, :clocked_in_at]
  end

  def down
    remove_index :user_follows, name: 'index_clock_ins_on_is_clocked_out_and_user_id'
    add_index :clock_ins, [:user_id, :clocked_in_at]
  end
end
