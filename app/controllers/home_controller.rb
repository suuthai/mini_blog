class HomeController < ApplicationController
  layout "home"
  before_action :authenticate_user!

  def index
  end
end
