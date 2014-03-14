class PacketController < ApplicationController
  def index
    @freshman = Freshman.find(1)
  end
end
