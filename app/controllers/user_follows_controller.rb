class UserFollowsController < ApplicationController
  def create
    actor = params[:actor]
    followee_id = params[:followee_id]

    unless User.exists?(actor)
      render_error(:not_found, I18n.t('errors.messages.record_not_found', record: 'Actor')) and return
    end

    unless User.exists?(followee_id)
      render_error(:not_found, I18n.t('errors.messages.record_not_found', record: 'Followee')) and return
    end

    follow = UserFollow.new(follower_id: actor, followee_id: followee_id)
    if follow.save
      render_success_no_data(I18n.t('success.messages.follow_success', followee_id: followee_id))
    else
      render_error(:internal_server_error, follow.errors.full_messages)
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
