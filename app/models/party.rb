class Party
  include Mongoid::Document
  #include Mongoid::Timestamps
  
  default_scope ->() { where(:start_time.gt => Time.now).order_by([[:start_time, :asc]]) }
  
  field :start_time, type: DateTime
  field :name, type: String
  field :facebook_url, type: String
  field :other_url, type: String
  field :location, type: String
end