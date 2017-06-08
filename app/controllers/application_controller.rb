class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_cart

  helper_method :current_immediately_cart

  helper_method :current_address

  def current_cart
    @current_cart ||= find_cart
  end

  def current_immediately_cart
    @current_immediately_cart ||= find_immediately_cart
  end

  def current_address
    @current_address ||= find_address
  end

  private

  def find_cart
    cart = Cart.find_by(id: session[:cart_id])
    if cart.blank?
      cart = Cart.create
    end
    session[:cart_id] = cart.id;
    return cart
  end

  def find_immediately_cart
    cart = Cart.find_by(id: session[:cart_id_temp])
    if cart.blank?
      cart = Cart.create
    end
    session[:cart_id_temp] = cart.id;
    return cart
  end

  def  find_address
    adrs = Address.where(:user_id => current_user.id).all
    adr_return = nil
    adrs.each_with_index do |adr, index|
      if 0 == index
        adr_return = adr
      elsif adr.is_default == 1
        adr_return = adr
      end
    end
    return adr_return
  end
end
