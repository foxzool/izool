class CityhunterController < ApplicationController
  def index
    if Rails.env.production?
      @geo = GeoIp.geolocation(current_account.current_sign_in_ip)
    else
      @geo = GeoIp.geolocation('58.246.55.174')
    end
  end

end
