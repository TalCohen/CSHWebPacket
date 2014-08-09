class FreshmenController < ApplicationController
  before_action :authenticate!

  def create
    # Just to be sure an admin is posting
    if admin_signed_in?
      # Get the freshman attributes
      freshman = params[:freshman]
      n = freshman[:name]
      p = freshman[:password]
      pc = freshman[:password_confirmation]
      dp = freshman[:doing_packet] == "1"
      op = freshman[:on_packet] == "1"

      # Create the freshman object and sends a message to the views
      new_freshman = Freshman.new(name: n, password: p, password_confirmation: pc, doing_packet: dp, on_packet: op)
      if new_freshman.save
        flash[:success] = "Successfully created freshman."
      else
        flash[:error] = "Unable to create freshman."
      end
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
        flash[:notice] = "Invalid username/password."
        redirect_to freshmen_path
      end
    end
  end

  def edit
    # If freshman does not exist, redirect
    if not Freshman.exists?(params[:id]) 
      flash[:error] = "Invalid freshman page."
      redirect_to freshmen_path
      return
    end

    # Get the freshman object
    @freshman = Freshman.find(params[:id])

    # If you're an upperclassman and not admin, redirect to show
    if upperclassman_signed_in? and not admin_signed_in?
      flash[:error] = "You cannot edit a freshman's info!"
      redirect_to freshman_path(@freshman.id)
    # If you're a freshman and you're not on your page, redirect to show
    elsif freshman_signed_in? and current_freshman != @freshman
      flash[:error] = "You can only edit your own info!"
      redirect_to freshman_path(@freshman.id)
    end

    # Define title
    @title = "#{@freshman.name}'s Info"
  end

  def destroy
    # Just to be sure an admin is deleting
    if admin_signed_in?
      # Get the freshman to delete and delete
      fresh = Freshman.find(params[:id])
      sigs = Signature.where(freshman_id: fresh.id) 
      fresh.destroy
      sigs.destroy_all
      if fresh.destroyed? and sigs.length == 0
        flash[:success] = "Successfully deleted freshman."
      else
        flash[:error] = "Unable to delete freshman."
      end
    end

    redirect_to freshmen_path
  end

  def index
    # Define title
    @title = "Freshmen Packets"

    # @freshmen will be a list of [Freshman, signature_length]
    @freshmen = []

    # Gets the Freshmen and how many signatures they have
    fresh = Freshman.where(doing_packet: true)

    fresh.each do |f|
      signatures_length = Signature.where(freshman: f).length
      @freshmen.push([f, signatures_length])
    end

    # Sort the freshmen based on highest signature count, then aphabetically
    @freshmen.sort! {|a,b| [b[1],a[0].name.downcase] <=> [a[1],b[0].name.downcase]}

    # Gets the total count of signatures on the packet (15 off-floor/alumni)
    @total_signatures = Upperclassman.where(alumni: false).length + Freshman.where(on_packet: true).length + 15
  end

  def show
    # If freshman does not exist, redirect
    if not Freshman.exists?(params[:id]) 
      flash[:error] = "Invalid freshman page."
      redirect_to freshmen_path
      return
    end

    # Get the freshman object
    @freshman = Freshman.find(params[:id])

    if @freshman.doing_packet
      # Define title
      @title = "#{@freshman.name}'s Packet"

      # Gets the signed upperclassmen and freshmen
      signatures = Signature.where(freshman_id: @freshman.id)
      @upperclassmen_signed = []
      @freshmen_signed = []

      signatures.each do |s|
        if s.signer_type == "Freshman" and s.signer.on_packet
          @freshmen_signed.push(s.signer)
        elsif s.signer_type == "Upperclassman" and not s.signer.alumni
          @upperclassmen_signed.push(s.signer)
        end
      end

      # Gets the unsigned upperclassmen and freshmen
      @upperclassmen_unsigned = Upperclassman.where(alumni: false) - @upperclassmen_signed
      @freshmen_unsigned = Freshman.where(on_packet: true) - @freshmen_signed

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
      elsif freshman_signed_in? and @current_freshman.on_packet
        @user_signature = Signature.exists?(freshman: @freshman, signer: @current_freshman)
        
      end

      @signature = Signature.new
    end
    if @freshman.on_packet
      # Define title
      @title = "#{@freshman.name}'s Signatures"

      # Get all freshmen objects doing the packet
      freshmen = Freshman.where(doing_packet: true).order(name: :asc)

      # Get the signed freshmen
      @signed_freshmen = []
      @freshman.signatures.each do |s|
        if s.freshman.doing_packet
          @signed_freshmen.push(s.freshman)
        end
      end

      # Sort the signed freshmen array alphabetically
      @signed_freshmen.sort_by!{ |s| s.name }

      # Get the unsigned freshmen
      @unsigned_freshmen = freshmen - @signed_freshmen

      # Gets the information for the progress bar
      @sig_progress = (100.0 * @signed_freshmen.length / freshmen.length).round(2).to_s  
    end
  
    if @freshman.doing_packet and @freshman.on_packet
      # Define title
      @title = "#{@freshman.name}'s Packet/Signatures"
    end

  end

  def update
    # Gets the freshman to update, and updates
    freshman = Freshman.find(params[:id])
    if not (admin_signed_in? or freshman == @current_freshman)
      flash[:error] = "You can only edit your own info!"
    else
      info = params[:freshman]
      result = nil
      if admin_signed_in?
        n = info[:name]
        dp = info[:doing_packet] == "1"
        op = info[:on_packet] == "1"
        result = freshman.update_attributes(name: n, doing_packet: dp, on_packet: op)
      elsif freshman == @current_freshman
        i_d = info[:info_directorships]
        i_e = info[:info_events]
        i_a = info[:info_achievements]
        result = freshman.update_attributes(info_directorships: i_d, info_events: i_e, info_achievements: i_a)
      end
      if result
        flash[:success] = "Successfully updated your information."
      else
        flash[:error] = "Unable to update your information."
      end
    end
    redirect_to :back
  end

end
