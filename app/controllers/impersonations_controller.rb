class ImpersonationsController < ApplicationController
  before_action :authorize_super_admin
  before_action :set_user, only: [ :create ]

  def create
    session_record = @user.sessions.create!
    cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

    redirect_to root_path, notice: "You are now impersonating #{@user.name}"
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def authorize_super_admin
    redirect_to root_path, alert: "You are not authorized to perform this action" unless current_user.super_admin?
  end
end
