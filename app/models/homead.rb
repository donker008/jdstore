class Homead < ApplicationRecord
  validates :product_id, presence:true
  validates :image , presence:true

  mount_uploader :image, ImageUploader
  def status_info
    if false == self.online
      "下线"
    else
      "上线"
    end
  end

  def product
    Product.find(self.product_id)
  end
end
