class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new create ]
  before_action :set_session, only: :new

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
    redirect_to clubs_path if Current.user
  end

  def create
    if (user = User.authenticate_by(email: params[:email], password: params[:password].presence))
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_origin_or_to clubs_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: "That email or password is incorrect"
    end
  end

  def destroy
    @session = Current.user.sessions.find(params[:id])
    @session.destroy; redirect_to(root_path, notice: "That session has been logged out")
  end
end
