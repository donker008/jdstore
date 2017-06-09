class Product < ApplicationRecord
  validates :title, presence:true
  validates :description, presence:true
  validates :price, presence:true
  validates :quantity, presence:true
  validates :category, presence:true
  mount_uploader :image, ImageUploader
  # belongs_to :product_category
  has_many :reviews

  def index_of_category
    ret_index = 0
    ProductCategory.all.each_with_index do |cate, index|
      if cate.name == self.category
        ret_index = index
        break
      end
    end
  end

 def prodcut_type
   type = "toy"
   if self.category == "喂养"
     type = "eat"
   else self.category == "儿童服饰" || self.category == "婴幼儿服饰"
     type = "cloth"
   end
 end

 def has_brought(user_id)
   orders = Order.where(:user_id => user_id).all
   orders.each do |order|
     order.product_lists.each do |product|
       if product.id == self.id
         return true
       end
     end
   end
   return false
 end

 def online_state
   if self.online == true
     "已上架"
   else
     "已下架"
   end
 end

end
