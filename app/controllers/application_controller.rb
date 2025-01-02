class ApplicationController < ActionController::API
  def render_error(status, messages)
    render json: {
      error: messages,
    }, status: status
  end

  def render_success_no_data(message)
    render json: {
      message: message,
    }, status: :ok
  end

  def render_success(data, message)
    render json: {
      data: data,
      message: message,
    }, status: :ok
  end

  def format_readable_timestamp(timestamp)
    timestamp.strftime("%B %d, %Y at %I:%M %p")
  end

  def format_sleep_length(seconds)
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    remaining_seconds = seconds % 60
    "#{hours} hours, #{minutes} minutes, #{remaining_seconds} seconds"
  end
end
