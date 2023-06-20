class School < ApplicationRecord
  has_many :batches
  has_many :courses
  has_many :school_admins, class_name: 'User'

  def school_admin?(user)
    school_admins.include?(user)
  end

  def eligible_admins
    User.school_admins.where(school_id: nil)
  end
end
