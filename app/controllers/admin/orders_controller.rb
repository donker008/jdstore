class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  layout "admin"

  def index
    if current_user.is_admin
      @orders = Order.all.order("created_at").paginate(:page => params[:page], :per_page => per_page)
    else
      redirect_to root_path
    end
  end

end
