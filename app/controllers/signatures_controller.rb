class SignaturesController < ApplicationController
  def index
    @freshmen = Freshman.all
    @upperclassmen = Array.new(Upperclassman.all)

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
