class UsercenterController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where(:user_id => current_user.id).all.order("created_at desc").paginate(:page => params[:page], :per_page => per_page)
  end

  def order
    @orders = Order.where(:user_id => current_user.id).all.order("created_at desc").paginate(:page => params[:page], :per_page => per_page)
    respond_to do |format|
      format.js
    end
  end

  def address
    @addresses = Address.all.paginate(:page => params[:page], :per_page => per_page)
    respond_to do |format|
       format.js
     end
  end

  def personal
    @user = current_user
    respond_to do |format|
       format.js
     end
  end

  def favorite
    @favorites = Favorite.all.paginate(:page => params[:page], :per_page => per_page);
    respond_to do |format|
       format.js
     end
  end

  def category
    @categoies = ProductCategory.all.order(:created_at).paginate(:page => params[:page], :per_page =>per_page);
    puts "category: " + @categoies.inspect
    respond_to do |format|
      format.js
    end
  end

  def product
    @products = Product.all.order(:created_at).paginate(:page => params[:page], :per_page =>per_page);
    @categoies = ProductCategory.all
    @isJSMode = 1
    puts "product: " + @products.inspect
    respond_to do |format|
      format.js
    end
  end
end
