class AddressesController < ApplicationController
  before_action :authenticate_user!

  def index
      @addresses = Address.all
      respond_to do |format|
        format.js
      end
  end

  def new
    @address = Address.new
  end

  def edit
    @address = Address.find(params[:id])
  end

  def create
    @address = Address.new(address_params)
    @address.user_id = current_user.id
    @address.save
    redirect_to addresses_path
  end

  def update
    @address = Address.find(params[:id])
    @address.update(address_params)
    redirect_to addresses_path
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.delete
      flash[:notice] = "地址删除成功"
    else
      flash[:warning] = "地址删除失败"
    end
    redirect_to addresses_path
  end

  private
  def address_params
    params.require(:address).permit(:name, :address, :contact_info)
  end
end
