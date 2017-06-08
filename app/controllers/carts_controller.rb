class CartsController < ApplicationController
  def index
    @cart = current_cart
    @immediately_cart = current_immediately_cart
    @categoies = ProductCategory.all
    @q  = Product.ransack(params[:q])
  end

  def clear
    current_cart.clear_cart
    current_cart.save
    # flash[:notice] = "已清空购物车"
    redirect_to :back
  end

  def remove_product
    do_remove_product(params[:id])
    redirect_to :back
  end

  def remove_immediately_product
    @product = Product.find(params[:id])
    if !@product.blank?
      quantity = current_immediately_cart.get_quantity(@product)
      current_immediately_cart.remove_product(@product)
      @product.quantity += quantity
      @product.save
      redirect_to :back
    else
      flash[:warning] = "商品已下架"
    end
  end

  def increase_product
    @product = Product.find(params[:id])
    if !@product.blank?
      if @product.quantity > 0
        if current_cart.increase_product(@product)
          @product.quantity = @product.quantity - 1
          @product.save
          # flash[:notice] = "成功增加一个商品"
        else
          flash[:notice] = "增加一个商品失败"
        end

      else
        # flash[:warning] = "商品库存不够，请一会再来"
      end
    else
      flash[:warning] = "商品已下架"
    end
    redirect_to :back
  end

  def decrease_product
    @product = Product.find(params[:id])
    if !@product.blank?
       if current_cart.decrease_product(@product)
         @product.quantity = @product.quantity + 1;
         @product.save
        #  flash[:notice] = "成功减少一个商品"
       else
        #  flash[:notice] = "减少一个商品失败"
       end

    else
      flash[:warning] = "商品已下架"
    end
    redirect_to :back
  end

  def checkout
    cartitem_ids = params[:product_ids];
    unless cartitem_ids.blank?
      current_cart.cart_items.each do |cart_item|
        if (cartitem_ids.include? cart_item.product.id) == false
          do_remove_product(cart_item.product.id);
          puts "do_remove_product: " + cart_item.product.id.to_s;
        end
      end
    end

    @order = Order.new
    @address = Address.where(:is_default => 1, :user_id => current_user.id).all.first
    if @address.blank?
       @address = Address.where(:user_id => current_user.id).all.first
    end
    @allAddress = Address.where(:user_id => current_user.id).all
  end

  private

  def do_remove_product(product_id)
    @product = Product.find(product_id)
    if !@product.blank?
      # flash[:notice] = "商品已从购物车拿掉"
      quantity = current_cart.get_quantity(@product)
      current_cart.remove_product(@product)
      @product.quantity += quantity
      @product.save

    else
      # flash[:warning] = "商品已下架"
    end
  end

end
