class Order < ApplicationRecord
  validates :billing_name , presence: true
  validates :billing_address, presence: true
  validates :shipping_name, presence: true
  validates :shipping_address, presence: true
  belongs_to :user
  has_many :product_lists

  before_create :generate_token

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
    if self.is_paid
      "已支付"
    else
      "未支付"
    end
  end
end