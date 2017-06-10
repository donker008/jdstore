class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where(:user_id => current_user.id).all.order("created_at desc").paginate(:page => params[:page], :per_page => per_page)
  end

  def indexJS
    @orders = Order.where(:user_id => current_user.id).all.order("created_at desc").paginate(:page => params[:page], :per_page => per_page)
  end

  def create
    @order =  Order.new(order_params)
    @order.user = current_user
    @order.total = current_cart.cart_total_price
    if @order.save
        current_cart.cart_items.each do |cart_item|
        product_list = ProductList.new
        product_list.order = @order
        product_list.product_name = cart_item.product.title
        product_list.product_price = cart_item.product.price
        product_list.quantity  = cart_item.quantity
        product_list.save
        current_cart.clear_cart
        OrderMailer.notify_order_placed(@order).deliver!
      end
      redirect_to order_path(@order.token)
    else
      render 'carts/checkout'
    end
  end

  def show
    @order = Order.find_by_token(params[:id])
    @product_lists = @order.product_lists
  end

  def pay_with_ailipay

    @order = Order.find_by_token(params[:id])
    @order.set_pay_method!("alipay")
    @order.make_payment!
    redirect_to order_path(@order.token), notice: "使用支付宝支付成功"
  end

  def pay_with_wechat
    @order = Order.find_by_token(params[:id])
    @order.set_pay_method!("wechat")
    @order.make_payment!
    redirect_to order_path(@order.token), notice: "使用微信支付成功"
  end

  def pay_now
    @order = Order.find_by_token(params[:id])
    if !@order.blank? &&  @order.can_pay?
      pay_method = params[:paymethod];
      puts "[pay_now] pay_method : " + pay_method + "id : "+ params[:id]
      @order.set_pay_method!(pay_method)
      @order.make_payment!
      render plain: "ok"
    else
      render plain: "no"
    end

  end

  def cancel
    @order = Order.find_by_token(params[:id])
    if current_user.is_admin
      @order.cancel_order!
      OrderMailer.notify_order_cancel_by_admin(@order).deliver!
      flash[:notice] = "取消订单成功"
      redirect_to :back
    else
      if @order.user_id == current_user.id
         @order.cancel_order!
         OrderMailer.notify_order_cancel(@order).deliver!
         flash[:notice] = "取消订单成功"
         redirect_to :back
      else
        flash[:warning] = "无法取消订单"
      end
    end

  end

  def ship
    @order = Order.find_by_token(params[:id])
    @order.ship!
    OrderMailer.notify_order_ship(@order).deliver!
    redirect_to usercenter_index_path(type: "order") ,notice:"商品出货成功"
  end

  def pay_method
      do_create_order
  end

  private

  def do_create_order
    @order = Order.new
    @order.shipping_name = current_address.name
    @order.shipping_address = current_address.address
    @order.billing_name = current_address.name
    @order.billing_address = current_address.address
    @order.user = current_user
    @order.total = current_cart.cart_total_price
    if @order.save

        current_cart.cart_items.each do |cart_item|
            product_list = ProductList.new
            product_list.order = @order
            product_list.product_name = cart_item.product.title
            product_list.product_price = cart_item.product.price
            product_list.quantity  = cart_item.quantity
            product_list.save
            current_cart.clear_cart
        end
      puts "do_create_order ok" + "order token : " + @order.token

    else
      puts "do_create_order error: " + @order.errors.full_messages.to_s
    end
  end

  def address_params
    params.require(:order).permit(:name, :address, :contact_info);
  end

  def order_params
    params.require(:order).permit(:billing_name, :billing_address, :shipping_name, :shipping_address,);
  end
end
