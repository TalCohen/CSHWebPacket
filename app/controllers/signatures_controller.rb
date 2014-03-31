class SignaturesController < ApplicationController
  def index
    @freshmen = Freshman.all
    @upperclassmen = Upperclassman.all
  end

  def update
    # Gets the signature to update, and updates
    signature = Signature.find(params[:id])

    signature.update_attributes(is_signed: true)
    redirect_to :back
  end
end
