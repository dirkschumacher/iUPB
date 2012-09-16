class FortyYearsEvent
  include Mongoid::Document
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :name, type: String
  field :description, type: String
  field :location, type: String
  field :link, type: String

  def name_with_date
  	"#{self.start_time.day}.#{self.start_time.month}.: #{self.name}"
  end
end
