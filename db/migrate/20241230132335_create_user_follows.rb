class CreateUserFollows < ActiveRecord::Migration[7.0]
  def up
    create_table :user_follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followee, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end

  def down
    drop_table :user_follows
  end
end
