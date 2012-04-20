class Course 
  include Mongoid::Document
  field :title, type: String
  field :title_downcase, type: String, index: true
  field :paul_id, type: String
  field :internal_course_id, type: String
  field :course_data, type: Array
  field :course_type, type: String
  field :paul_url, type: String
  field :group_title, type: String
  key :internal_course_id
end