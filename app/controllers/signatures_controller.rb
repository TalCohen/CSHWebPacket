class SignaturesController < ApplicationController
  before_action :authenticate_upperclassman!

  def index
    # Define title
    @title = "Packet Grid"

    # Get sorted freshmen and upperclassmen
    @freshmen = Freshman.where(active: true).order(name: :asc)
    #@freshmen.sort! {|a,b| a <=> b}

    @upperclassmen = Array.new(Upperclassman.where(alumni: false).order(name: :asc))
    #@upperclassmen.sort! {|a,b| a <=> b}

    if @user and not @user.alumni
      # Put user at front of grid
      @upperclassmen.unshift(@upperclassmen.delete(Upperclassman.find(@user.id)))
    end

  end

  def update
    # Gets the signature to update, and updates
    signature = Signature.find(params[:id])

    signature.update_attributes(is_signed: true)
    redirect_to :back
  end
end
