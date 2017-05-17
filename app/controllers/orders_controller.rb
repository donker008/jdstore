class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where(:user_id => current_user.id).all
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
    @order.pay!
    redirect_to order_path(@order.token), notice: "使用支付宝支付成功"

  end

  def pay_with_wechat
    @order = Order.find_by_token(params[:id])
    @order.set_pay_method!("wechat")
    @order.pay!
    redirect_to order_path(@order.token), notice: "使用微信支付成功"
  end

  private


  def order_params
    params.require(:order).permit(:billing_name, :billing_address, :shipping_name, :shipping_address,);
  end
end