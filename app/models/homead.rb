class Homead < ApplicationRecord
  validates :product_id, presence:true
  validates :image , presence:true

  mount_uploader :image, ImageUploader
  def status_info
    if false == self.online
      "已下架"
    else
      "已上架"
    end
  end

  def product
    if self.product_id
      Product.find(self.product_id)
    end
  end
end
