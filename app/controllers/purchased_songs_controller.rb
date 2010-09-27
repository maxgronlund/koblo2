class PurchasedSongsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :sidebar_for_user
  layout 'user_content'

  def index
    # Completed orders - newest first
    @purchase_items = PurchaseItem.for_user(current_user).completed.order('created_at DESC')
  end

end
