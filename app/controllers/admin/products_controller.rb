class Admin::ProductsController < ApplicationController
 layout "admin"
 before_action :authenticate_user!
 before_action :admin_require

 def index
   @products = Product.all.order("created_at desc").paginate(:page => params[:page], :per_page => per_page)
   @categoies = ProductCategory.all.order("created_at desc")
 end

 def new
   @product = Product.new
   @categoies = ProductCategory.all
 end

 def create
   @product = Product.new(product_params)
   if @product.save
     flash[:notice] = "create product success!"
     redirect_to usercenter_index_path(type: "product_all")
   else
     flash[:alert] = "failed to create product!";
     render :new;
   end
 end

 def update
   @product = Product.find(params[:id])
   @categoies = ProductCategory.all
   if @product.update(product_params)
     flash[:notice] = "update product success!"
   else
     flash[:alert] = "更新商品信息失败" + @product.errors.full_messages.to_s
   end
   redirect_to usercenter_index_path(type: "product_all")
 end

 def edit
   @product = Product.find(params[:id])
   @categoies = ProductCategory.all
 end

 def show
   @product = Product.find(params[:id])
 end

 def destroy
   @product = Product.find(params[:id])
   if @product.delete
     flash[:notice] = "delete product success!"
   else
     flash[:alert] = "failed to delete product!"
   end
   redirect_to usercenter_index_path(type: "product_all")
 end

 def filter_by_category
   @category = ProductCategory.find(params[:id])
   @products = Product.where(:category => @category.name).all
   @categoies = ProductCategory.all
 end

 def set_online
   online = params[:online].to_i
   @product = Product.find(params[:id])
   @product.online = online == 1 ? true: false
   @product.save
   render plain: "ok"
 end

 private

 def product_params
   params.require(:product).permit(:title, :description, :price, :quantity, :image, :category, :online)
 end


 def admin_require
     if !current_user.is_admin?
       redirect_to "/"
     end
  end
end
