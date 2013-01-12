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
  end
end
