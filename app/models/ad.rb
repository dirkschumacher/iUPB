class Ad
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  field :name, type: String, index: true
  field :text, type: String
  field :email, type: String
  field :admin_token, type: String
  belongs_to :user
  
  validates :name, :text, :email, :admin_token, presence: true
  def to_slug
    self.name.parameterize
  end
end