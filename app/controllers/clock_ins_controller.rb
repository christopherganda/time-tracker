class ClockInsController < ApplicationController
  def upsert
    user_id = params[:actor]
    last_unused_clock_in = ClockIn.where(
      user_id: user_id, 
      is_clocked_out: false
      ).order(clocked_in_at: :desc).first

    current_time = Time.now
    if last_unused_clock_in
      SleepRecord.create!(
        user_id: user_id,
        clock_in_id: last_unused_clock_in.id,
        clock_in_at: last_unused_clock_in.clocked_in_at,
        clock_out_at: current_time
      )
      render_success("test", I18n.t('success.messages.clock_out_success'))
    else
      ClockIn.create!(
        user_id: user.id,
        clocked_in_at: Time.now
      )
      render_success("test", I18n.t('success.messages.clock_in_success'))
    end
  rescue ActiveRecord::RecordInvalid => e
    render_error(:unprocessable_entity, e.message)
  end
end