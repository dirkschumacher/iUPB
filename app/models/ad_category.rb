class AdCategory
  include Mongoid::Document
  
  field :name, type: String
  belongs_to :parent, class_name: "AdCategory", inverse_of: :children
  has_many :children, class_name: "AdCategory", inverse_of: :parent
  
  validates :name, presence: true
end