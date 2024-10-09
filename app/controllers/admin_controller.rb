class AdminController < ApplicationController
  skip_before_action :authenticate
  before_action :authenticate_admin

  private

  def authenticate_admin
    set_session
    redirect_to '/sign_in', alert: "You are not authorized to access this page." unless current_user&.email == "yosefserkez@gmail.com"
  end
end