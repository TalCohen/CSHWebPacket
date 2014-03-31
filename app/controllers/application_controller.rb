require_relative 'packet_ldap'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do
    begin
      ldap = PacketLdap::Ldap.new
      user = ldap.find_by_username(request.env['REMOTE_USER'])[0]
      user_uuid = user.entryuuid[0]
      @user = Upperclassman.find_by uuid: "#{user_uuid}"
    rescue
      @user = nil
    end
  end


end
