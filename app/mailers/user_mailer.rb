class UserMailer < ApplicationMailer
  def password_reset
    @user = params[:user]
    @signed_id = @user.generate_token_for(:password_reset)

    mail to: @user.email, subject: "Reset your password"
  end

  def email_verification
    @user = params[:user]
    @signed_id = @user.generate_token_for(:email_verification)

    mail to: @user.email, subject: "Verify your email"
  end

  def invitation_instructions
    @user = params[:member].user
    @club = params[:club]
    @inviter = params[:inviter]
    @unsubscribe_token = params[:member].generate_token_for(:club_unsubscribe)
    @signed_id = @user.generate_token_for(:password_reset)

    mail(to: @user.email, subject: "Welcome to #{@club.title}!")
  end

  def platform_updates(user, update_content)
    @user = user
    @update_content = update_content
    mail(to: @user.email, subject: "New Features Available!")
  end
end
