class Ad
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Slug
  include Mongoid::Paperclip
  
  include Tire::Model::Search
  include Tire::Model::Callbacks

  index_name "ads-#{Rails.env}"

  mapping do
    indexes :id,         :index    => :not_analyzed
    indexes :title,      :analyzer => 'snowball', :boost => 100
    indexes :text,       :analyzer => 'snowball'
    indexes :name,       :analyzer => 'keyword'
    indexes :category_name,       :analyzer => 'keyword'
    indexes :created_at, :type => 'date', :include_in_all => false
  end
  
  # These Mongo guys sure do get funky with their IDs in +serializable_hash+, let's fix it.
  def to_indexed_json
   self.to_json(only: [:id, :title, :text, :name, :created_at], methods: [:category_name])
  end

  field :title, type: String, index: true
  field :name, type: String
  field :text, type: String
  field :email, type: String
  field :admin_token, type: String
  field :publish_email, type: Boolean, default: false
  field :views, type: Integer, default: 0
  
  has_mongoid_attached_file :photo,styles: {
    square: '200x200#',
    medium: '400x400>'
  }
  
  slug :title
  
  belongs_to :user
  belongs_to :ad_category
  
  validates :title, :name, :text, :email, :ad_category_id, presence: true
  
  validates :name, :text, :email, :admin_token, presence: true
  def to_slug
    self.name.parameterize
  end
  def category_name
    self.ad_category.name
  end
end