class Course < ApplicationRecord
  belongs_to :school
  has_many :batches

  def eligible_batches(user)
    binding.pry
    batches.where.not(id: user.request_batch_id) - user.batches
  end
end
