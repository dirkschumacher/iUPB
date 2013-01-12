class AdCategory
  include Mongoid::Document
  
  field :name, type: String
  
  belongs_to :parent, class_name: "AdCategory", inverse_of: :children
  has_many :children, class_name: "AdCategory", inverse_of: :parent
  
  has_many :ads
  
  validates :name, presence: true
  
  # @tailrec
  def all_ads
    if self.children
      self.ads + self.children.flat_map(&:all_ads)
    else
      self.ads
    end
  end
  
  def parents
    parents_ar = []
    obj = self
    until obj.parent.nil?
      parents_ar << obj.parent
      obj = obj.parent
    end
    parents_ar + [self]
  end
  
  def breadcrumb(delimiter = " > ")
    self.parents.map(&:name).join(delimiter)
  end

end