class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def the_best
    current_best = question.answers.find_by_best(true)
    ActiveRecord::Base.transaction do
      current_best&.update!(best: false)
      update!(best: true)
    end
  end
end
