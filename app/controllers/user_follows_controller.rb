class UserFollowsController < ApplicationController
  def create
    actor = params[:actor]
    followee_id = params[:followee_id]

    unless User.exists?(actor)
      render json: { error: "Follower/actor does not exist" }, status: :not_found and return
    end

    unless User.exists?(followee_id)
      render json: { error: "Followee does not exist" }, status: :not_found and return
    end

    follow = UserFollow.new(follower_id: actor, followee_id: followee_id)
    if follow.save
      render json: { message: "Successfully followed user #{followee_id}" }, status: :ok
    else
      render json: { error: follow.errors.full_messages }, status: :internal_server_error
    end
  end

  def destroy
    actor = params[:actor]
    followee_id = params[:followee_id]

    follow = UserFollow.find_by(follower_id: actor, followee_id: followee_id)
    if follow
      follow.destroy
      render json: { message: "Successfully unfollowed user #{followee_id}" }, status: :ok
    else
      render json: { error: "Following relationship does not exist" }, status: :not_found
    end
  end
end
