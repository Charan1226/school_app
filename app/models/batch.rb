class Batch < ApplicationRecord
  belongs_to :school
  belongs_to :course
  has_and_belongs_to_many :students, -> { where(role: 'student') }, class_name: 'User'

  def eligible_students
    User.students - students
  end

  def applied_students
    User.students.select { |u| u.request_batch_id.include?(id) } 
  end
end
