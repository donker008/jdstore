class ProductsController < ApplicationController

  def index
    @products = Product.all
    @all_products =  Hash.new
    @categoies = ProductCategory.all
    @products.each do |product|
         product_temps = @all_products[product.category]
         if product_temps.blank?
           product_temps = Array.new
           @all_products[product.category] = product_temps
         end
         product_temps.push(product)
    end
    @q  = Product.ransack(params[:q])

  end

  def show
    @product = Product.find(params[:id])
    @categoies = ProductCategory.all
    @q  = Product.ransack(params[:q])
  end

  def add_to_cart
    @product = Product.find(params[:id])
    if !@product.blank?
      if !current_cart.is_product_added?(@product)
          current_cart.add_product_to_cart(@product)
          flash[:notice] = "商品已添加到购物车"
      else
        flash[:warning] = "本商品已在购物车"
      end
    else
      flash[:warning] = "商品已下架"
    end
    redirect_to :back
  end

  def buy_immediately
    @product = Product.find(params[:id])
    current_immediately_cart.clear_cart
    if !@product.blank?
      if !current_immediately_cart.is_product_added?(@product)
          current_immediately_cart.add_immediately_product_to_cart(@product)
          puts "1 :" + current_immediately_cart.id.to_s+ current_immediately_cart.to_s
      end
    end
    redirect_to carts_path
  end

  def filter_by_category
    @category = ProductCategory.find(params[:id])
    @products = Product.where(:category => @category.name).all
    @categoies = ProductCategory.all
    @q  = Product.ransack(params[:q])
  end

  def favorite

    @product = Product.find(params[:id])
    unless @product.blank?
      if Favorite.isExist?(params[:id])
        flash[:notice] = "商品已收藏"
      else
        @favorite = Favorite.new
        @favorite.product_id = @product.id
        @favorite.user_id = current_user.id
        @favorite.save
        flash[:notice] = "商品收藏成功"
      end
    else
      flash[:warning] = "商品收藏失败!"
    end
    redirect_back(fallback_location: :back)
  end


   def  search
      @q  = Product.ransack(params[:q])
      @products = @q.result(distict: true)
   end

  private
  def product_params
    params.require(:product).permit(:title, :description, :price, :quantity)
  end
end
