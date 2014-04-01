class FreshmenController < ApplicationController
  def index
    @freshmen = []

    # Gets the freshmen and how many signatures they have
    fresh = Freshman.all
    fresh.each do |f|
      signatures = f.signatures.where(is_signed: true)
      @freshmen.push([f, signatures.length])
      end
    @freshmen.sort! {|a,b| b[1] <=> a[1]}
  end

  def show
    @freshman = Freshman.find(params[:id]) # Get the freshman object

    # Gets the signatures and upperclassmen needed
    f_signatures = @freshman.signatures 
    @signatures = []
    signed = 0.0
    f_signatures.each do |s|
      @signatures.push([Upperclassman.find(s.upperclassman_id).name, s])
      if s.is_signed
        signed += 1
      end
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
