class UpperclassmenController < ApplicationController
  def index
    # Define title
    @title = "Upperclassmen Packets"

    @upperclassmen = []
    # Gets the upperclassmen and how many signatures they have
    uppers = Upperclassman.where(alumni: false)
    uppers.each do |u|
      signatures = u.signatures.where(is_signed: true)
      @upperclassmen.push([u, signatures.length])
      end
    # Sort the upperclassmen based on highest signature count, then alphabetically
    @upperclassmen.sort! {|a,b| [b[1],a[0].name.downcase] <=> [a[1],b[0].name.downcase]}
  end

  def show
    # If no paramaters are given, make the it user's page.
    if not params[:id]
      params[:id] = @user.id
    end

    # If upperclassman exists, get upperclassman object, otherwise redirect
    if Upperclassman.exists?(params[:id])
      @upperclassman = Upperclassman.find(params[:id])
    else
      flash[:notice] = "Invalid upperclassman page"
      redirect_to upperclassmen_path
      return
    end

    # Define title
    @title = "#{@upperclassman.name}'s Packet"

    # Gets the signatures and freshmen objects needed
    u_signatures = @upperclassman.get_signatures
    @signatures = []
    signed = 0.0
    u_signatures.each do |s|
      # signatures will be a list of [Freshman, Signature]
      @signatures.push([Freshman.find(s.freshman_id).name, s])
      if s.is_signed
        signed += 1
      end
    end

    # Gets the information for the progress bar
    progress = (signed / u_signatures.length * 100).round(2)
    @progress = progress.to_s

  end
end
