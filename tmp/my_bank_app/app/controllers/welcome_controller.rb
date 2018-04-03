class WelcomeController < ApplicationController
  def index
    @message = "Hello world"
    @user = User.first
  end
end
