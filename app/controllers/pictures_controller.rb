class PicturesController < ApplicationController

  before_filter :authenticate_user!, :only => [:destroy]

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

