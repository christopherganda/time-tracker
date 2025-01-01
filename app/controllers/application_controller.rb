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
end
