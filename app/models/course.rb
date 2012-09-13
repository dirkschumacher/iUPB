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
  
  #comma sperated list of lectures
  field :meta_lecturer_names, type: String, index: true
  field :meta_rooms, type: String , index: true
  key :internal_course_id
  
  def get_dates(future=true)
    dates = []
    self.course_data.each do |c|
      start_time = Time.mktime(c["date"].year, c["date"].month, c["date"].day, c["time_from"].to_time.hour, c["time_from"].to_time.min)   #mktime(year, month, day, hour, min)
      end_time = Time.mktime(c["date"].year, c["date"].month, c["date"].day, c["time_to"].to_time.hour, c["time_to"].to_time.min)
      dates << [start_time, end_time, c["room"], c["instructor"]] unless future && start_time < Time.now
    end
    dates
  end
end