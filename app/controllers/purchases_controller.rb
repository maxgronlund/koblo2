class PaymentsController < ApplicationController
  before_filter :sidebar_for_user
  layout 'user_content'

  def new
    @purchase = current_user.purchases.create
    @purchase.purchase_items.create(:song_id => params[:song_id])
  end
end
