class PagesController < ApplicationController
  skip_before_action :authenticate
  before_action :set_session, only: :landing
  def landing
  end
end
