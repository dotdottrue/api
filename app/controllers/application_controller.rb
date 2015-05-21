class ApplicationController < ActionController::Base
	require 'openssl'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session,
      if: Proc.new { |c| c.request.format =~ %r{application/json} }
  helper_method :timestampValidation

  def timestampValidation(timestamp)
  	server_time = Time.now.to_i
  	later_server_time = server_time + 300
  	earlier_server_time = server_time - 300

  	if (earlier_server_time .. later_server_time).include?(timestamp)
  		return true
  	else
  		return false
  	end
  end

end
