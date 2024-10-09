class RegistrationsController < ApplicationController
  skip_before_action :authenticate
  before_action :set_session, only: :new

  def new
    redirect_to clubs_path if Current.user
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(verified: true))

    if @user.save
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

      # send_email_verification
      redirect_origin_or_to new_club_path, notice: "Welcome! You have signed up successfully"
    else
      flash.now[:alert] = @user.errors.full_messages.join("<br/>")
      render :new, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :name, :timezone)
    end

    def send_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end
end
