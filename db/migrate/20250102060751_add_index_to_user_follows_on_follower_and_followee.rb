class AddIndexToUserFollowsOnFollowerAndFollowee < ActiveRecord::Migration[7.0]
  def up
    add_index :user_follows, [:follower_id, :followee_id], unique: true, name: 'index_user_follows_on_follower_id_and_followee_id'
  end

  def down
    add_index :user_follows, name: 'index_user_follows_on_follower_id_and_followee_id'
  end
end
