class FreshmenController < ApplicationController
  def create
    # Just to be sure an admin is posting
    if @admin
      # Get the name entered
      fresh = params[:freshman][:name]
      # Create the freshman object
      f = Freshman.new
      f.create_freshman(fresh)
      redirect_to :back
    elsif @freshman_user
      # Really bad way of doing this, in my opinion, but oh well.
      name = params[:freshman][:name]
      password = params[:freshman][:password]
      @user = Freshman.find_by(name: name, password: password)
      if @user
        params[:id] = @user.id
        @freshman_first = false
        show
      else
        flash[:notice] = "Invalid username/password"
        redirect_to freshmen_path
      end
    end

  end

  def destroy
    # Just to be sure an admin is deleting
    if @admin
      # Get the freshman to delete and delete
      fresh = Freshman.find(params[:id])
      fresh.destroy
    end

    redirect_to freshmen_path
  end

  def index
    # Define title
    @title = "Freshmen Packets"

    # Gets the total count of signatures on the packet (15 off-fllor/alumni)
    @total_signatures = Upperclassman.where(alumni: false).length + 15

    @freshmen = []
    # Gets the active freshmen and how many signatures they have
    fresh = Freshman.where(active: true)
    fresh.each do |f|
      upper_signatures = f.signatures.includes(:upperclassman).where(is_signed: 
                                  true, "upperclassmen.alumni" => false)
      alumni_signatures = f.signatures.includes(:upperclassman).where(is_signed:
                                true, "upperclassmen.alumni" => true).limit(15)
      signatures_length = upper_signatures.length + alumni_signatures.length
      @freshmen.push([f, signatures_length])
    end
    # Sort the freshmen based on highest signature count, then aphabetically
    @freshmen.sort! {|a,b| [b[1],a[0].name.downcase] <=> [a[1],b[0].name.downcase]}


  end

  def show
    # If freshman does not exist, or if the freshman is not active and you are not admin, redirect
    if not Freshman.exists?(params[:id]) or (not Freshman.find(params[:id]).active and not @admin)
      flash[:notice] = "Invalid freshman page"
      redirect_to freshmen_path
      return
    end

    # Get the freshman object
    @freshman = Freshman.find(params[:id])

    # Define title
    @title = "#{@freshman.name}'s Packet"

    # Gets the signatures and upperclassmen needed
    f_signatures = @freshman.get_signatures
    @signatures = []
    signed = 0.0
    f_signatures.each do |s|
      # signatures will be a list of [Upperclassman, Signature]
      @signatures.push([Upperclassman.find(s.upperclassman_id).name, s])
      if s.is_signed
        signed += 1
      end
    end

   # Gets the alumni signatures as a list of [Alumni, Signature] or nil
   @alumni_signatures = @freshman.get_alumni_signatures
   
   # Gets the amount of alumni signatures
   alumni_count = @alumni_signatures.select { |s| s != nil }.length
   signed += alumni_count
     
    # Gets the information for the progress bar
    progress = (signed / (f_signatures.length + @alumni_signatures.length) * 100).round(2)
    @progress_color = ""
    if progress < 10
      @progress_color = "progress-bar-danger"
    elsif progress < 60
      @progress_color = "progress-bar-warning"
    elsif progress < 100
      @progress_color = "progress-bar-info"
    else
      @progress_color = "progress-bar-success"
    end
    @progress = progress.to_s

    # Gets the signature that the user is looking at
    if @user
      @user_signature = @user.signatures.find_by(freshman_id: @freshman.id)
    end
  end

  def update
    # Gets the freshman to update, and updates
    freshman = Freshman.find(params[:id])

    freshman.update_attributes(active: !freshman.active)
    redirect_to :back
  end

end
