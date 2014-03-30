class SignaturesController < ApplicationController
  def index
    @freshmen = Freshman.all
    @upperclassmen = Upperclassman.all
  end

  def update
  end
end
