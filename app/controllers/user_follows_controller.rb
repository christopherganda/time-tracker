class UserFollowsController < ApplicationController
  include UserFinder

  def create
    followee_id = params[:followee_id]

    unless User.exists?(followee_id)
      render_error(:not_found, I18n.t('errors.messages.record_not_found', record: 'Followee')) and return
    end

    begin
      follow = UserFollow.create!(follower_id: @user.id, followee_id: followee_id)
      render_success_no_data(I18n.t('success.messages.follow_success', followee_id: followee_id))
    rescue ActiveRecord::RecordNotUnique
      render_error(:conflict, I18n.t('activerecord.errors.has_been_followed'))
    rescue ActiveRecord::RecordInvalid => e
      # need to find a way to return proper error message
      # because rails error append the key
      render_error(:unprocessable_entity, e.record.errors.full_messages)
    end
  end

  def destroy
    actor = params[:actor]
    followee_id = params[:followee_id]

    UserFollow.transaction do
      follow = UserFollow.lock.find_by(follower_id: actor, followee_id: followee_id)
      if follow
        follow.destroy!
        render_success_no_data(I18n.t('success.messages.unfollow_success', followee_id: followee_id))
      else
        render_error(:not_found, I18n.t('errors.messages.relationship_not_exist'))
      end
    end
  rescue => e
    render_error(:unprocessable_entity, e.message)
  end

  private
  def requires_user_finder?
    action_name.in?(%w[create])
  end
end
