class TracksController < ApplicationController

  # Watch this https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/3913
  skip_before_filter :verify_authenticity_token, :only => :create
  
  def create
    @track = current_user.tracks.build(params[:track])
    @track.uploaded_data_content_type = MIME::Types.type_for(@track.uploaded_data_file_name).to_s

    respond_to do |format|
      if @track.save
        format.json { render :json => { :result => 'success' } }        
      else
        format.json { render :json => { :result => 'fail' } }        
      end
    end
  end

end
