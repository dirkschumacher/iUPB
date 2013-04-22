class Event
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  #include Mongoid::Timestamps
  field :start_time, type: DateTime, default: ->{ DateTime.now + 15.minutes }
  field :end_time, type: DateTime
  field :name, type: String
  field :recurring, type: Boolean
  field :recurring_style, type: String
  field :recurring_end, type: Date
  field :description, type: String
  field :course_id, type: String
  field :location, type: String
  field :custom, type: Boolean, default: false

  belongs_to :parent_event, :class_name => 'Event'
  after_update :update_recurring
  after_create :create_recurring

  embedded_in :user
  
  with_options :if => "course.nil?" do |event|
    event.validates :start_time, presence: true
    event.validates :name, presence: true
  end
  
  validate :start_time_greater_than_today, :end_time_greater_than_start_time, :recurring_end_greater_than_start_time

  def children_events
    self.user.events.where(parent_event_id: self.id)
  end

  def update_recurring # untested. might be an infinite loop. TODO
    if self.recurring or self.parent_event
      (self.recurring ? self : self.parent_event).children_events.each do |e|
        e.update_attributes(name: self.name, start_time: self.start_time, end_time: self.end_time, location: self.location)
      end
    end
  end

  def create_recurring
    if self.recurring
      interval = case self.recurring_style
        when "daily" then 1
        when "1week" then 7
        when "2weeks" then 14
        else 30
      end
      added_days = interval
      # create events until we reached the recurring end. here we iterate over the days to be added.
      until added_days > ([self.recurring_end.to_date, Date.today + 2.years].min - self.start_time.to_date).to_i
        new_event = self.dup
        new_event.user = self.user
        new_event.recurring = false
        new_event.parent_event = self
        new_event.start_time = self.start_time + added_days.days
        new_event.end_time = self.end_time + added_days.days
        new_event.save

        added_days += interval
      end
    end
  end


  def _name
    if self.course and !self.custom
      return self.course.title if self.course.course_type === "course"
      return self.course.group_title if self.course.course_type === "group"
    end
    self.name
  end
  
  def short_title 
      return self.course.course_short_desc if !self.custom and self.course and !self.course.course_short_desc.blank? 
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
  
  def _parent_event
    self.user.events.find(parent_event_id) if parent_event_id
  end

  protected
  def end_time_greater_than_start_time
      if !end_time.blank? and end_time < start_time
        errors.add(:end_time, "can't be set before start time")
      end
  end

  def start_time_greater_than_today
      if course.nil? && start_time && start_time < DateTime.now
        errors.add(:start_time, "can't be in the past")
      end
  end

  def recurring_end_greater_than_start_time
      if recurring
        if recurring_end
          errors.add(:recurring_end, "can't be set before start time") if recurring_end < start_time.to_date
        else
          errors.add(:recurring_end, "cannot be blank")
        end
        
      end
  end
end