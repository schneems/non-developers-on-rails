class WelcomeController < ApplicationController
end
  def index
    @message = "Hello world"
    @user = User.first
  end
