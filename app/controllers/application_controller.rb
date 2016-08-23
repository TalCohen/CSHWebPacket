require_relative 'packet_ldap'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  force_ssl

  private

  def get_ldap_user
    ldap = PacketLdap::Ldap.new
    username = request.env['REMOTE_USER']
    return nil if username == nil
    user = ldap.find_by_username(username)[0]
  end

  def intromember?(uuid)
    ldap = PacketLdap::Ldap.new
    intromembers = ldap.find_intromembers
    return intromembers.select { |intro| intro.entryuuid[0] == uuid }.length > 0
  end

  def create_alumni
    ldap = PacketLdap::Ldap.new
    username = request.env['REMOTE_USER']
    user = ldap.find_by_username(username)[0]
    upper = Upperclassman.new
    alumni = upper.create_upperclassman(user, false, true)
  end

  def current_upperclassman
    return @current_upperclassman if @current_upperclassman

    user = get_ldap_user
    uuid = user.entryuuid[0] if user
    if uuid
      # Check to see if it's a freshman that just got an account
      return nil if intromember?(uuid)

      if Upperclassman.exists?(uuid: uuid)
        @current_upperclassman ||= Upperclassman.find_by(uuid: uuid) 
      else
        # Create the alumni
        @current_upperclassman = create_alumni
      end
    end
  end

  def current_admin
    current_upperclassman if current_upperclassman and current_upperclassman.admin
  end

  def current_session
    if session[:current_freshman_id] and Freshman.exists?(session[:current_freshman_id])
      true unless Time.now > session[:last_seen] + 1.hour or Time.now > session[:created_at] + 1.day
    end
  end

  def current_freshman
    if current_session
      session[:last_seen] = Time.now
      @current_freshman ||= Freshman.find(session[:current_freshman_id])
    else
      session.delete(:current_freshman_id)
      @current_freshman = nil
    end
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
