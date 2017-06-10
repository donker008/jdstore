class Admin::HomeadsController < ApplicationController
  before_action :authenticate_user!

  def index
    @homeads = Homead.all
  end

  def new
    @homead = Homead.new
    @products = Product.where(:online => true).all
  end

  def edit
    @homead = Homead.find(params[:id])
    @products = Product.where(:online => true).all
  end

  def update
    @homead = Homead.find(params[:id])
    if @homead.update(homaead_params)
      flash[:notice] = "更新首页广告成功"
    else
      flash[:alert] = "更新首页广告失败"
    end
    redirect_to usercenter_index_path(type: "product_ad")
  end

  def create
    @homead = Homead.new(homaead_params)
    if @homead.save
      flash[:notice] = "创建首页广告成功"
    else
      flash[:alert] = "创建首页广告失败"
    end
    redirect_to usercenter_index_path(type: "product_ad")
  end

  def destroy
    @homead = Homead.find(params[:id])
    unless @homead.blank?
        if @homead.delete
          flash[:notice] = "删除首页广告成功"
        else
          flash[:alert] = "删除首页广告成功"
        end
    else
      flash[:alert] = "首页广告不存在"
    end
    redirect_to usercenter_index_path(type: "product_ad")
  end

  def set_online
    @homead = Homead.find(params[:id])
    @homead.online = params[:online]
    @homead.save
    render plain: "ok"
  end

  private
  def homaead_params
    params.require(:homead).permit(:name, :priority, :image, :online, :product_id)
  end
end
