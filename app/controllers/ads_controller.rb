class AdsController < ApplicationController
  def index
    @categories = AdCategory.where(parent_id: params[:category]||nil).asc(:name)
    if params[:category]
      @category = AdCategory.find(params[:category])
    end

    if params[:q] && !params[:q].empty?
      qry = ->(query) do
        query.string params[:q]
      end
      
      @ads = Ad.tire.search do
        query &qry
        if @category
          filter do
            {:category_id => @category.id}
          end
        end
        facet 'categories' do
          terms :category_id
        end
      end
      
      pp @ads #DEBUG
    else
      if @category
       @ads = @category.all_ads
      else
       @ads = @categories.flat_map(&:all_ads)
      end
      @ads = @ads.sort {|a,b| b <=> a}
    end
  end

  def new
    @ad = Ad.new
    @ad.email = current_user.email if user_signed_in?
  end
  
  def edit
    @ad = Ad.where(admin_token: params[:admin_token]).first
  end
  
  def update
    @ad = Ad.where(admin_token: params[:admin_token]).first
    if @ad.update_attributes(params[:ad])
      redirect_to @ad, notice: t(".notice_saved")
    else
      render "edit"
    end
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
    @ad.track_view
  end

  def create
    @ad = Ad.new(params[:ad])
    @ad.user = current_user if user_signed_in?
    @ad.ensure_admin_token
    if @ad.save
      AdMailer.ad_created_email(@ad).deliver
      redirect_to @ad, notice: t(".notice_saved")
    else
      render "new"
    end
  end
  
  def report
    @ad = Ad.find(params[:id])
    @contact = ContactUs::Contact.new
    @contact.subject = "REPORT: #{@ad.title} by #{@ad.name}"
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
