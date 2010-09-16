class PaymentsController < ApplicationController
  before_filter :sidebar_for_user
  layout 'user_content'
end
