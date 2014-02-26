class WelcomeController < ApplicationController
  def index
    @signatures = Signature.all
  end
end
