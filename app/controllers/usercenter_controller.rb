class UsercenterController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where(:user_id => current_user.id).all.order("created_at desc").paginate(:page => params[:page], :per_page => per_page)
  end

  def order
    @orders = Order.where(:user_id => current_user.id).all.order("created_at desc").paginate(:page => params[:page], :per_page => per_page)
    respond_to do |format|
      format.js
    end
  end

  def address
    @addresses = Address.all.paginate(:page => params[:page], :per_page => per_page)
    respond_to do |format|
       format.js
     end
  end

  def personal
    @user = current_user
    respond_to do |format|
       format.js
     end
  end

  def favorite
    @favorites = Favorite.all.paginate(:page => params[:page], :per_page => per_page);
    respond_to do |format|
       format.js
     end
  end

  def category
    @categoies = ProductCategory.all.order(:created_at).paginate(:page => params[:page], :per_page =>per_page);
    puts "category: " + @categoies.inspect
    respond_to do |format|
      format.js
    end
  end

  def product
    @products = Product.all.order(:created_at).paginate(:page => params[:page], :per_page =>per_page);
    @categoies = ProductCategory.all
    @isJSMode = 1
    puts "product: " + @products.inspect
    respond_to do |format|
      format.js
    end
  end

  def filterbycategory

    puts 'filterbycategory: ' + params.inspect

    @isJSMode = 1
    @category = ProductCategory.find(params[:id])
    @products = Product.where(:category => @category.name).all
    @categoies = ProductCategory.all
    @q  = Product.ransack(params[:q])

    puts 'filterbycategory: category :' + @category.inspect

    puts 'filterbycategory: products :' + @products.inspect

    respond_to do |format|
      format.js
    end
  end

  def update_user_info
    if current_user.update(user_params)
      flash[:notice] = "用户资料修改成功"
    else
      flash[:notice] = "用户资料修改失败"
    end
    redirect_to :back;
  end

  def upload_user_avatar
    @user = current_user
  end

  def do_upload_user_avatar
    puts "1 do_upload_user_avatar: " + user_avartar_params.inspect
    if current_user.avatar.file.exists?
      flash[:notice] = "头像文件已经存在"
      redirect_to usercenter_index_path
      return
    end

    if current_user.update(user_avartar_params)
      flash[:notice] = "更新头像成功"
    else
      flash[:notice] = "更新头像失败"
    end
    puts "2 do_upload_user_avatar -> current_user:" + current_user.inspect
    redirect_to usercenter_index_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :nick_name, :sex, :birthday, :phone, :address);
  end

  def user_avartar_params
    params.require(:user).permit(:avatar,:name, :nick_name, :sex, :birthday, :phone, :address);
  end
end
