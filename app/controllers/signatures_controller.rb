class SignaturesController < ApplicationController
  def index
    # Define title
    @title = "Packet Grid"

    # Get sorted freshmen and upperclassmen
    @freshmen = Freshman.all
    @freshmen.sort! {|a,b| a <=> b}

    @upperclassmen = Array.new(Upperclassman.all)
    @upperclassmen.sort! {|a,b| a <=> b}

    if @user
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
