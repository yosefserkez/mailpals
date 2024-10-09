class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :set_current_request_details
  before_action :authenticate
  around_action :set_time_zone, if: :current_user

  attr_reader :current_user, :current_session

  def current_user
    Current.user
  end

  def render_flash
    render turbo_stream: turbo_stream.update("flash", partial: "shared/toast")
  end

  def redirect_origin_or_to(fallback, **options)
    path = session[:redirect_path] || fallback
    session.delete(:redirect_path)
    redirect_to path, options
  end

  rescue_from ActionPolicy::Unauthorized do |ex|
    redirect_back_or_to root_path, allow_other_host: false, alert: "You are not authorized to perform this action."
  end

  private

  def authenticate
    if set_session
      Current.session
    else
      session[:redirect_path] = request.fullpath unless session_path?
      redirect_to sign_in_path
    end
  end

  def set_session
    Current.session = Session.find_by_id(cookies.signed[:session_token])
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end

  def session_path?
    request.path == sign_in_path || request.path == sign_up_path
  end

  private

  def set_time_zone(&block)
    timezone = Current.user&.timezone || request.headers["HTTP_TIME_ZONE"] || "Eastern Time (US & Canada)"
    Time.use_zone(timezone, &block)
  end
end
