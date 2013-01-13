class AdsController < ApplicationController
  def index
    @categories = AdCategory.where(parent_id: params[:category]||nil)
    if params[:category]
      @category = AdCategory.find(params[:category])
    end

    if params[:search] && !params[:search].empty?
      qry = ->(query) do
        query.string params[:search]
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
      
      pp @ads
    else
      if @category
       @ads = @category.all_ads
      else
       @ads = @categories.flat_map(&:all_ads)
      end
    end
  end

  def new
    @ad = Ad.new
    @ad.email = current_user.email if user_signed_in?
  end
  
  def edit
  end

  def remove
  end
  
  def show
    @ad = Ad.find(params[:id])
  end

  def create
    @ad = Ad.new(params[:ad])
    @ad.user = current_user if user_signed_in?
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
