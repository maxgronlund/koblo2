class ConnectionsController < ApplicationController

  def index
    current_user.connections.paginate(:per_page => 9, :page => (params[:page] || 1))
  end
end
