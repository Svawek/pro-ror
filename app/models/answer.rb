class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def the_best!
    current_best = question.answers.find_by_best(true)
    transaction do
      current_best&.update!(best: false)
      update!(best: true)
    end
  end
end
