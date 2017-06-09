class Order < ApplicationRecord
  validates :billing_name , presence: true
  validates :billing_address, presence: true
  validates :shipping_name, presence: true
  validates :shipping_address, presence: true
  belongs_to :user
  has_many :product_lists

  before_create :generate_token

  include AASM

  aasm do
    state :order_placed, initial:true
    state :paid
    state :shipping
    state :shipped
    state :order_cancelled
    state :good_returned

    event :make_payment, after_commit: :pay! do
      transitions from: :order_placed, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipping
    end

    event :deliver do
      transitions from: :shipping , to: :shipped
    end

    event :return_good do
      transitions from: :shipped, to: :good_returned
    end

    event :cancel_order do
      transitions from: [:order_placed, :paid], to: :order_cancelled
    end

  end

  def generate_token
      self.token = SecureRandom.uuid
  end

  def set_pay_method!(method)
    self.update_columns(payment_method: method)
  end

  def pay!
    self.update_columns(is_paid: true)
  end

  def pay_state_info
    if self.aasm_state == "order_cancelled"
      "订单已取消"
    elsif self.aasm_state == "paid"
      "已支付(" + payment_method + ')'
    elsif self.aasm_state == "shipping"
      "出货中"
    elsif self.aasm_state == "shipped"
      "到货"
    elsif self.aasm_state == "good_returned"
      "退货"
    elsif self.aasm_state == "order_placed"
      "未支付"
    else
      "未知"
    end
  end

  def can_pay?
    if self.aasm_state == "order_placed"
      return true
    else
      return false
    end
  end

  def can_cancel?
    if self.aasm_state == "order_placed" || self.aasm_state == "paid"
      return true
    else
      return false
    end
  end

  def can_ship?
    if self.aasm_state == "paid"
      return true
    else
      return false
    end
  end

  # class method define
  def self.hot24_products
      where_string  = "and  aasm_state != 'order_cancelled' and aasm_state != 'order_placed' "
      query = 'created_at >= :one_day_ago ' + where_string
      orders = Order.where(query,
      :one_day_ago => Time.now - 1.days)
      if orders.blank?
        query = 'created_at >= :one_month_ago ' + where_string
        orders = Order.where(query,
        :one_month_ago => Time.now - 30.days)
      end

      puts "hot24 query " + query

      producthash =  Hash.new
      orders.each do | order |
        order.product_lists.each do |product|
          count = producthash[product.id]
          if count.blank?
            count = 0
          end
          count += product.quantity
          producthash[product.id] = count
        end
      end

      producthash_sorted = producthash.sort_by{|key,value| value }
      product_ids =  Array.new
      producthash_sorted.each_with_index do | key_value , index|
        if index < 10
          product_id = key_value[0]
          product_ids.push(product_id)
        else
          break
        end
      end
      products = Product.where(id: product_ids)
  end

end
