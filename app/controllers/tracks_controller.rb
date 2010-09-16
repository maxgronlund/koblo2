class TracksController < ApplicationController

  before_filter :authenticate_user!, :only => [:create, :destroy]

  def create
    @track = current_user.tracks.build(params[:track])
    @track.uploaded_data_content_type = MIME::Types.type_for(@track.uploaded_data_file_name).to_s
    @track.title = @track.uploaded_data_file_name.gsub(/(.*)\.(.*?)$/, '\1').humanize.titleize if @track.title.blank?

    respond_to do |format|
      if @track.save
        format.js
      end
    end
  end

end
