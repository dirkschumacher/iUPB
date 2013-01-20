class Ad
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  include Mongoid::Slug
  include Mongoid::Paperclip
  
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  attr_protected :views

  mapping do
    indexes :id,         :index    => :not_analyzed
    indexes :title,      :analyzer => 'snowball', :boost => 100
    indexes :text,       :analyzer => 'snowball'
    indexes :name,       :analyzer => 'keyword'
    indexes :category_id, :index    => :not_analyzed
    indexes :category_name,       :analyzer => 'keyword'
    indexes :created_at, :type => 'date', :include_in_all => false
  end
  
  # These Mongo guys sure do get funky with their IDs in +serializable_hash+, let's fix it.
  def to_indexed_json
   self.to_json(only: [:id, :title, :text, :name, :created_at], methods: [:category_name, :square_photo_url])
  end

  field :title, type: String, index: true
  field :name, type: String
  field :text, type: String
  field :email, type: String
  field :alternative_thumbnail_url, type: String
  field :admin_token, type: String
  field :price, type: String
  field :publish_email, type: Boolean, default: false
  field :views, type: Integer, default: 0
  
  has_mongoid_attached_file :photo, styles: {
    square: '200x200#',
    medium: '400x400>'
  }
  
  slug :title
  
  belongs_to :user
  belongs_to :ad_category
  
  validates :title, :name, :text, :ad_category_id, presence: true
  validates :email, presence: true, format: { with: /^([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/i }
  
  validates :name, length: { maximum: 100 }
  validates :title, length: { maximum: 100 }
  validates :price, length: { maximum: 20 }
  validates :email, length: { maximum: 60 }
  validates :text, length: { minimum: 10 }
  
  def track_view
    self.inc(:views, 1)
  end
  
  def to_slug
    self.name.parameterize
  end
  def category_name
    self.ad_category.name
  end
  
  def ensure_admin_token
    self.update_attribute(:admin_token, random_token) unless self.admin_token
  end
  
  def square_photo_url
    if self.photo?
      self.photo.url(:square)
    else
      self.alternative_thumbnail_url unless self.alternative_thumbnail_url.blank?
    end
  end
  
  
  # the "super cool ranking algorithm" is 
  # "a multifactor, linear and continuous-time model based ranking algorithm"
  # we use for ordering our ads ;)
  def normalized_views
    - (self.views / (Time.now - self.created_at)) * 10000
  end
  
  protected
  #thanks: http://stackoverflow.com/a/88341
  def random_token
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    (0...50).map{ o[rand(o.length)] }.join
  end
  
end