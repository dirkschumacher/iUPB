class Course 
  include Mongoid::Document
  field :title, type: String
  field :paul_id, type: Integer, unique: true
  field :internal_course_id, type: String, unique: true
  field :course_data, type: Array
end