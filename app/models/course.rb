class Course 
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
  field :meta_lecturer_names, type: String
  field :meta_rooms, type: String 
  key :internal_course_id
end