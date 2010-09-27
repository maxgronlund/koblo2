class WelcomeBackController < ApplicationController
  def landing_page
    redirect_to user_purchased_songs_path(current_user), :notice => 'Now go ahead and download the stuff you bought'
  end
end

