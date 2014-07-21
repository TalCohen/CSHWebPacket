class SessionsController < ApplicationController
  def new
  end

  def create
    freshman = Freshman.find_by_name(params[:name])
    if freshman and freshman.authenticate(params[:password])
      session[:current_freshman_id] = freshman.id
      redirect_to root_url
    else
      flash[:notice] = "Invalid username/password"
      redirect_to :back
    end
  end

  def destroy
  end
end
