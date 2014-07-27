class FreshmenController < ApplicationController
  before_action :authenticate!

  def create
    # Just to be sure an admin is posting
    if admin_signed_in?
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
    if admin_signed_in?
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
    if not Freshman.exists?(params[:id]) or (not Freshman.find(params[:id]).active and not admin_signed_in?)
      flash[:notice] = "Invalid freshman page"
      redirect_to freshmen_path
      return
    end

    # Get the freshman object
    @freshman = Freshman.find(params[:id])

    # If you're a freshman and you're not on your page, redirect
    unless upperclassman_signed_in?
      if freshman_signed_in? and current_freshman != @freshman
        flash[:notice] = "Can only edit own info!"
        redirect_to freshmen_path
      end
    end

    # Define title
    @title = "#{@freshman.name}'s Packet"

    # Gets the signed upperclassmen and freshmen
    signatures = Signature.where(freshman_id: @freshman.id)
    @upperclassmen_signed = []
    @freshmen_signed = []

    signatures.each do |s|
      if s.signer_type == "Freshman" and s.signer.active and s.signer.on_packet
        @freshmen_signed.push(s.signer)
      elsif s.signer_type == "Upperclassman" and not s.signer.alumni
        @upperclassmen_signed.push(s.signer)
      end
    end

    # Gets the unsigned upperclassmen and freshmen
    @upperclassmen_unsigned = Upperclassman.where(alumni: false) - @upperclassmen_signed
    @freshmen_unsigned = Freshman.where(active: true, on_packet: true) - @freshmen_signed

    # Sort the arrays alphabetically
    @upperclassmen_signed.sort_by!{ |s| s.name }
    @upperclassmen_unsigned.sort_by!{ |s| s.name }
    @freshmen_signed.sort_by!{ |s| s.name }
    @freshmen_unsigned.sort_by!{ |s| s.name }

    # Gets the alumni signatures as a list of alumni
    @alumni_signed = @freshman.get_alumni_signatures

    # Gets the information for the progress bar
    signed = @upperclassmen_signed.length + @freshmen_signed.length + @freshman.get_alumni_signatures_count
    total = signed + @upperclassmen_unsigned.length + @freshmen_unsigned.length + @alumni_signed.length - @freshman.get_alumni_signatures_count
    progress = (100.0 * signed / total).round(2)
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

    # Determine whether this packet is signed or not
    if upperclassman_signed_in?
      @user_signature = Signature.exists?(freshman: @freshman, signer: @current_upperclassman)
    elsif freshman_signed_in?
      @user_signature = Signature.exists?(freshman: @freshman, signer: @current_freshman)
    end

    @signature = Signature.new
  end

  def update
    # Gets the freshman to update, and updates
    freshman = Freshman.find(params[:id])

    freshman.update_attributes(active: !freshman.active)
    redirect_to :back
  end

end
