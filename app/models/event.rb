class Event
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  #include Mongoid::Timestamps
  field :start_time, type: DateTime, default: ->{ DateTime.now + 15.minutes }
  field :end_time, type: DateTime
  field :name, type: String
  field :recurring, type: Boolean
  field :recurring_style, type: Symbol
  field :recurring_end, type: DateTime
  field :description, type: String
  field :course_id, type: String
  field :location, type: String

  embedded_in :user
  
  with_options :if => "course.nil?" do |event|
    event.validates :start_time, presence: true
    event.validates :name, presence: true
  end
  
  validate :start_time_greater_than_today, :end_time_greater_than_start_time
  
  def _name
    if self.course
      return self.course.title if self.course.course_type === "course"
      return self.course.group_title if self.course.course_type === "group"
    end
    self.name
  end
  
  def short_title 
      return self.course.course_short_desc if self.course and self.course.course_short_desc.length > 0 
      self.name
  end
  
  def start_time_utc
    self.start_time.utc
  end
  def end_time_utc
    self.end_time.utc
  end
  def course
    if self.course_id
      Course.find(self.course_id)
    else
      nil
    end
  end
  
  def course=(course)
    self.course_id = "#{course.id}"
  end

  protected
  def end_time_greater_than_start_time
      if !end_time.blank? and end_time < start_time
        errors.add(:end_time, "can't be set before start time")
      end
  end

  def start_time_greater_than_today
      if start_time && start_time < DateTime.now
        errors.add(:start_time, "can't be in the past")
      end
  end
end
