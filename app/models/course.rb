class Course 
  attr_accessor :next_class
  
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :title_downcase, type: String, index: true
  field :paul_id, type: String
  field :internal_course_id, type: String
  field :course_data, type: Array
  field :course_type, type: String, index: true
  field :paul_url, type: String
  field :group_title, type: String
  field :course_short_desc, type: String
  field :course_short_desc_downcase, type: String, index: true
  
  #comma sperated list of lectures
  field :meta_lecturer_names, type: String, index: true
  field :meta_rooms, type: String , index: true
  key :internal_course_id
  
  def get_dates(future=true)
    dates = []
    self.course_data.each do |c|
      date = c["date"]
      time_from = c["time_from"].to_time
      time_to = c["time_to"].to_time
      instructor = c["instructor"]
      room = c["room"]
      start_time = combine date, time_from
      end_time = combine date, time_to
      unless future and start_time < Time.now
        dates << [start_time, end_time, room, instructor] 
      end
    end
    dates
  end
  
  def update_next_class_information!()
    min_interval = 100.days
    self.course_data.each do |data|
      date = data["date"]
      time_from_key = "time_from"
      time_to_key = "time_from"
      time_from = combine date, data[time_from_key].to_time
      time_to = combine date, data[time_to_key].to_time
      interval = time_to - Time.now
      data[time_from_key] = time_from
      data[time_to_key] = time_to
      if time_to >= Time.now and interval < min_interval
        self.next_class = {
          room: data['room'].length == 0 ? t('courses.room_na') : data['room'],
          time_from: time_from,
          time_to: time_to
          #instructor: data['instructor']
        }
        min_interval = interval
      end
    end
  end
  
  private
  
  def combine(date, time) 
    Time.new(date.year, date.month, date.day, time.hour, time.min)
  end
end