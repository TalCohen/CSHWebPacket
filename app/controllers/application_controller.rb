require_relative 'packet_ldap'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

=begin
  before_action do
    # Find current user
      ldap = PacketLdap::Ldap.new
      username = request.env['REMOTE_USER']

      if username == nil # User is accessing from freshmen-packet.csh
        @freshman_user = true 
        @freshman_first = true
        @user = nil
        
        # Redirect to freshmen index
        controller = params[:controller]
        action = params[:action]
        if not (controller == "freshmen" and (action == "index" or action == "create"))
          redirect_to freshmen_path
        end
      else # User is accessing from packet.csh
        @freshman_user = false
        user = ldap.find_by_username(username)[0]
        user_uuid = user.entryuuid[0]
        @user = Upperclassman.find_by uuid: "#{user_uuid}"
      
        # Check if user is nil (not onfloor upperclassman)
        if @user == nil
          # Create upperclassman as alumni
          @user = Upperclassman.new
          @user.create_upperclassman(user, alumni=true)
        end

        # Check if user is admin
        admin = File.read("/var/www/priv/packet/admin.txt").chomp
        if @user.uuid == admin
          @admin = true
        end
      end

      # Instantiate title
      @title = ""
  end
=end
  ##                 ##
  ## NEW RESTRUCTURE ##
  ##                 ##


  private

  def get_uuid
    ldap = PacketLdap::Ldap.new
    username = request.env['REMOTE_USER']
    return nil if username == nil
    user = ldap.find_by_username(username)[0]
    uuid = user.entryuuid[0]
  end

  def current_upperclassman
    @current_upperclassman ||= Upperclassman.find_by(uuid: get_uuid) 
  end

  def current_admin
    current_upperclassman if current_upperclassman and current_upperclassman.admin
  end

  def current_freshman
    @current_freshman ||= Freshman.find(session[:current_freshman_id]) if session[:current_freshman_id]
  end

  %w(upperclassman admin freshman).each do |role|
    define_method("#{role}_signed_in?") do
      send("current_#{role}").present?
    end

    define_method("authenticate_#{role}!") do
      unless send("#{role}_signed_in?")
        redirect_to new_sessions_path
      end
    end
  end

  def signed_in?
    freshman_signed_in? || upperclassman_signed_in? 
  end

  def authenticate!
    unless signed_in?
      redirect_to new_sessions_path
    end
  end

end
