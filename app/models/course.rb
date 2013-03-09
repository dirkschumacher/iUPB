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
      start_time = Time.new(date.year, date.month, date.day, time_from.hour, time_from.min)
      end_time = Time.new(date.year, date.month, date.day, time_to.hour, time_to.min)
      unless future and start_time < Time.now
        dates << [start_time, end_time, room, instructor] 
      end
    end
    dates
  end
end