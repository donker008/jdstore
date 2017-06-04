module CartsHelper

  def get_current_cart
     if @immediately_cart.available
        @immediately_cart
     else
       @cart
     end
  end
end
