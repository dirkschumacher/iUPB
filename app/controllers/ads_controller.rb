class AdsController < ApplicationController
  def index
  end

  def new
    @ad = Ad.new
  end
  
  def edit
    @ad = Ad.where(admin_token: params[:admin_token])
  end

  def remove
    @ad = Ad.where(admin_token: params[:admin_token]).first
  end
  
  def destroy
    @ad = Ad.where(admin_token: params[:admin_token])
    @ad.delete
      redirect_to ads_path, notice: t(".notice_deleted")
  end
  
  def create
    @ad = Ad.new(params[:ad])
    @ad.user = current_user if user_signed_in?
    @ad.admin_token = random_token
    if @ad.save
      redirect_to ads_path, notice: t(".notice_saved")
    else
      render "new"
    end
  end
end
