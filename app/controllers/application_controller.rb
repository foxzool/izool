class ApplicationController < ActionController::Base
  before_filter :authenticate_account!

  protect_from_forgery
end
