class FreshmenController < ApplicationController
  def create
    # Just to be sure an admin is posting
    if @admin
      # Get the name entered
      fresh = params[:freshman][:name]
      # Create the freshman object
      f = Freshman.create(name: fresh)
      # Create the signature relationship to each upperclassman.
      Upperclassman.all.each do |u|
        s = Signature.create(freshman_id: f.id, upperclassman_id: u.id)
      end
    end

    redirect_to :back
  end

  def destroy
    # Just to be sure an admin is deleting
    if @admin
      # Get the freshman to delete and delete
      fresh = Freshman.find(params[:id])
      fresh.destroy
    end

    redirect_to freshmen_index_path
  end

  def index
    # Define title
    @title = "Freshmen Packets"

    @freshmen = []
    # Gets the freshmen and how many signatures they have
    fresh = Freshman.all
    fresh.each do |f|
      signatures = f.signatures.where(is_signed: true)
      @freshmen.push([f, signatures.length])
    end
    # Sort the freshmen based on highest signature count, then id
    @freshmen.sort! {|a,b| [b[1],a[0].id] <=> [a[1],b[0].id]}
  end

  def show
    @freshman = Freshman.find(params[:id]) # Get the freshman object

    # Define title
    @title = "#{@freshman.name}'s Packet"

    # Gets the signatures and upperclassmen needed
    f_signatures = @freshman.signatures 
    @signatures = []
    signed = 0.0
    f_signatures.each do |s|
      @signatures.push([Upperclassman.find(s.upperclassman_id).name, s])
      if s.is_signed
        signed += 1
      end
    # Sort the signatures
    @signatures.sort! {|a,b| b[1] <=> a[1]} 
    end
     
    # Gets the information for the progress bar
    progress = (signed / f_signatures.length * 100).round(2)
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
end
