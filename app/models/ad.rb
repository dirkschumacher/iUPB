class Ad
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  field :name, type: String, index: true
  field :text, type: String
  field :email, type: String
  
  belongs_to :user
  
  validates :name, :text, :email, presence: true
end