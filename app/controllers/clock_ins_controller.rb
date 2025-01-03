class ClockInsController < ApplicationController
  include UserFinder
  include Retryable

  def upsert
    current_time = Time.now

    with_retry do
      ActiveRecord::Base.transaction do
        last_unused_clock_in = ClockIn.where(
          is_clocked_out: false,
          user_id: @user.id
          )
          .order(clocked_in_at: :desc)
          .limit(1)
          .lock(true)
          .first

        if last_unused_clock_in
          last_unused_clock_in.update!(is_clocked_out: true)
          SleepRecord.create!(
            user_id: @user.id,
            clock_in_id: last_unused_clock_in.id,
            clocked_in_at: last_unused_clock_in.clocked_in_at,
            clocked_out_at: current_time
          )

          render_success(@user.clock_ins_json, I18n.t('success.messages.clock_out_success'))
        else
          ClockIn.create!(
            user_id: @user.id,
            clocked_in_at: current_time
          )

          render_success(@user.clock_ins_json, I18n.t('success.messages.clock_in_success'))
        end
      end
    end
  end

  private
  def requires_user_finder?
    action_name.in?(%w[upsert])
  end
end