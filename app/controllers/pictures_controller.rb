class PicturesController < ApplicationController

  before_filter :authenticate_user!, :only => [:destroy]

  # Watch this https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/3913
  skip_before_filter :verify_authenticity_token, :only => :create
  
  def create
    @picture = Picture.new(params[:picture] || { :picture => params[:Filedata] })
    @picture.picture_content_type = MIME::Types.type_for(@picture.picture_file_name).to_s
    @picture.save

    respond_to do |format|
      if @picture.save
        format.js
      end
    end
  end

end

