class Ad
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  field :name, type: String, index: true
  field :text, type: String
  field :email, type: String
  field :views, type: Integer
  
  belongs_to :user
  belongs_to :ad_category
  
  validates :name, :text, :email, presence: true
end