class ApplicationController < ActionController::Base
	require 'openssl'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :timestampValidation

  def timestampValidation(timestamp)
  	server_timestamp = Time.now.to_i
  	server_timestamp_greater = server_timestamp + 300
  	server_timestamp_smaller = server_timestamp - 300

  	if (server_timestamp_smaller .. server_timestamp_greater).include?(timestamp)
  		return true
  	else
  		return false
  	end
  end

end
