class UpperclassmenController < ApplicationController
  def index
  end

  def show
    @upperclassman = Upperclassman.find(params[:id]) # Get the upperclassman object

    # Gets the signatures and freshmen objects needed
    u_signatures = @upperclassman.signatures
    @signatures = []
    signed = 0.0
    u_signatures.each do |s|
      @signatures.push([Freshman.find(s.freshman_id).name, s])
      if s.is_signed
        signed += 1
      end
    end

    # Gets the information for the progress bar
    progress = (signed / u_signatures.length * 100).round(2)
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

  end
end
