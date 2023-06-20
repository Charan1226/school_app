class User < ApplicationRecord
  serialize :request_batch_id, Array
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_and_belongs_to_many :batches
  belongs_to :school, optional: true
  enum role: { admin: 'admin', school_admin: 'school_admin', student: 'student' }

  scope :students, -> { where(role: 'student') }
  scope :school_admins, -> { where(role: 'school_admin') }
  validates_uniqueness_of :request_batch_id

  def admin?
    role == 'admin'
  end

  def school_admin?
    role == 'school_admin'
  end

  def student?
    role == 'student'
  end
end
