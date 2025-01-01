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
