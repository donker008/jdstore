class AddressesController < ApplicationController
  before_action :authenticate_user!

  def index
      @addresses = Address.all.order("created_at desc").paginate(:page => params[:page], :per_page => per_page)
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

  def address_list
    @addresses = Address.where(:user_id => current_user.id).all.paginate(:page => params[:page], :per_page => per_page)
  end

  def set_default
    @address = Address.find(params[:id])
    if !@address.blank? && @address.user_id = current_user.id
      address_temps = Address.where(:user_id => current_user.id).all
      address_temps.each do |adr|
        adr.is_default = 0
        adr.save
      end

      @address.is_default = 1
      @address.save
    end
    redirect_to :back
  end


  private
  def address_params
    params.require(:address).permit(:name, :address, :contact_info)
  end
end
