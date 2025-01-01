class SleepRecordsController < ApplicationController
  include UserFinder

  def get
    resp = @user.followings_sleep_records
           .map do |record|
            {
              followee_id: record.followee_id,
              sleep_length: format_sleep_length(record.sleep_length.to_i),
              clocked_in_at: format_readable_timestamp(record.clocked_in_at),
              clocked_out_at: format_readable_timestamp(record.clocked_out_at)
            }
          end
    render_success(resp, "")
  end

  private
  def requires_user_finder?
    action_name.in?(%w[get])
  end
end
