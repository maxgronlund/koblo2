class PurchasedSongsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :sidebar_for_user
  layout 'user_content'

  def index
    @purchase_items = current_user.purchase_items.completed
  end

end
