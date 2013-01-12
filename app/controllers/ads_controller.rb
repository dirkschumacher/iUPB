class AdsController < ApplicationController
  def index
    @categories = AdCategory.where(parent_id: params[:category]||nil)
    @ads = @categories.flat_map(&:all_ads)
  end

  def new
    @ad = Ad.new
  end
  
  def edit
  end

  def remove
  end
  
  def show
    @ad = Ad.find(params[:id])

  def create
    @ad = Ad.new(params[:ad])
    @ad.user = current_user if user_signed_in?
    if @ad.save
      redirect_to ads_path, notice: t(".notice_saved")
    else
      render "new"
    end

  end
end
