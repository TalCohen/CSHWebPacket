class SignaturesController < ApplicationController
  before_action :authenticate!

  def create
    freshman_id = params[:signature][:freshman]
    # Check if the freshman exists, if it's on the packet, and 
    # check if a signature already exists with that signer
    if Freshman.exists?(freshman_id)
      freshman = Freshman.find(freshman_id)
      if freshman.doing_packet
        if upperclassman_signed_in? and not Signature.exists?(freshman: freshman, signer: @current_upperclassman)
          Signature.create(freshman: freshman, signer: @current_upperclassman)
        elsif freshman_signed_in? and not Signature.exists?(freshman: freshman, signer: @current_freshman)
          Signature.create(freshman: freshman, signer: @current_freshman)
        else
          flash[:error] = "Unable to sign packet"
        end
      else
        flash[:error] = "Freshman is not doing the packet"
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
      @freshmen = Freshman.where(doing_packet: true).order(name: :asc)

      @upperclassmen = Array.new(Upperclassman.where(alumni: false).order(name: :asc))

      unless @current_upperclassman.alumni
        # Put user at front of grid
        @upperclassmen.unshift(@upperclassmen.delete(Upperclassman.find(@current_upperclassman.id)))
      end

      @freshmen_on_packet = Freshman.where(on_packet: true).order(name: :asc)
      f_ids = []
      @freshmen.each {|f| f_ids << f.id }
      @upperclass_signatures = Hash.new
      @freshmen_signatures = Hash.new
      Signature.where(freshman_id: f_ids).each do |s|
          if s.signer_type == "Upperclassman"
              @upperclass_signatures[[s.signer_id, s.freshman_id]] = s
          else
              @freshmen_signatures[[s.signer_id, s.freshman_id]] = s
          end
      end
    elsif freshman_signed_in?
      # Define title
      @title = "CSH Packet"
    end
  end

  def destroy
    if admin_signed_in? # Just to be sure an admin is posting
      signature_id = params[:id]
      if Signature.exists?(signature_id)
        signature = Signature.find(signature_id)
        signature.destroy
        if signature.destroyed?
          flash[:success] = "Successfully deleted signature."
        else
          flash[:error] = "Unable to delete signature."
        end
      else
        flash[:error] = "Signature does not exist."
      end
    end
    return redirect_to :back
  end

end
