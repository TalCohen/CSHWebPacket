class SignaturesController < ApplicationController
  before_action :authenticate!

  def create
    freshman_id = params[:signature][:freshman]
    # Check if the freshman exists, if it's active and on the packet, and 
    # check if a signature already exists with that signer
    if Freshman.exists?(freshman_id)
      freshman = Freshman.find(freshman_id)
      if freshman.active and freshman.on_packet
        if upperclassman_signed_in? and not Signature.exists?(freshman: freshman, signer: @current_upperclassman)
          Signature.create(freshman: freshman, signer: @current_upperclassman)
	elsif freshman_signed_in? and not Signature.exists?(freshman: freshman, signer: @current_freshman)
          Signature.create(freshman: freshman, signer: @current_freshman)
	else
          flash[:error] = "Unable to sign packet"
	end
      else
        flash[:error] = "Unable to sign packet"
      end
    else
      flash[:error] = "Freshman does not exist"
    end
    redirect_to :back
  end

  def index
    if upperclassman_signed_in?
      # Define title
      @title = "Packet Grid"

      # Get sorted freshmen and upperclassmen
      @freshmen = Freshman.where(active: true).order(name: :asc)

      @upperclassmen = Array.new(Upperclassman.where(alumni: false).order(name: :asc))

      unless @current_upperclassman.alumni
        # Put user at front of grid
        @upperclassmen.unshift(@upperclassmen.delete(Upperclassman.find(@current_upperclassman.id)))
      end

      @freshmen_on_packet = Freshman.where(active: true, on_packet: true).order(name: :asc)
    elsif freshman_signed_in?
      # Define title
      @title = "CSH Packet"
    end
  end
end
