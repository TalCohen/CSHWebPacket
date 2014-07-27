class SignaturesController < ApplicationController
  before_action :authenticate_upperclassman!

  def index
    # Define title
    @title = "Packet Grid"

    # Get sorted freshmen and upperclassmen
    @freshmen = Freshman.where(active: true, on_packet: true).order(name: :asc)

    @upperclassmen = Array.new(Upperclassman.where(alumni: false).order(name: :asc))

    unless @current_upperclassman.alumni
      # Put user at front of grid
      @upperclassmen.unshift(@upperclassmen.delete(Upperclassman.find(@current_upperclassman.id)))
    end

  end

  def update
    # Gets the signature to update, and updates
    signature = Signature.find(params[:id])

    signature.update_attributes(is_signed: true)
    redirect_to :back
  end
end
