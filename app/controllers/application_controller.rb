require_relative 'packet_ldap'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do
    # Find current user
    begin
      ldap = PacketLdap::Ldap.new
      user = ldap.find_by_username(request.env['REMOTE_USER'])[0]
      user_uuid = user.entryuuid[0]
      @user = Upperclassman.find_by uuid: "#{user_uuid}"
      
      # Check if user is nil (not onfloor upperclassman)
      if @user == nil
        # Create upperclassman as alumni
        @user = Upperclassman.new
        @user.create_upperclassman(user, alumni=true)
      end

      # If user is admin, admin is true
      admin = File.read("/var/www/priv/packet/admin.txt").chomp
      if @user.uuid == admin
        @admin = true
      end
    rescue
      @user = nil
      @admin = nil
    end
    
    # Instantiate title
    @title = ""
    
  end


end
