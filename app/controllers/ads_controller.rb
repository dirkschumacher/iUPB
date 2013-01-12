class AdsController < ApplicationController
  def index
    @categories = AdCategory.where(parent_id: params[:category]||nil)
    @ads = @categories.flat_map(&:all_ads)
  end

  def new
    @ad = Ad.new
    @ad.email = current_user.email if user_signed_in?
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
  
  def show
    @ad = Ad.find(params[:id])
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
  
  def report
    @ad = Ad.find(params[:id])
    @contact = ContactUs::Contact.new
    @contact.subject = "REPORT: #{@ad.title} by #{@ad.name}"    # TODO
    @contact.message = "DELETE: #{remove_ad_url(@ad, admin_token: @ad.admin_token)}\n" + 
      "EDIT: #{edit_ad_url(@ad, admin_token: @ad.admin_token)}"
    @contact.email = "support@yippie.io"

    if @contact.save
      redirect_to(ad_path(@ad), :notice => t('.success'))
    else
      redirect_to(ad_path(@ad), :notice => t('.error')) 
    end
  end
end
