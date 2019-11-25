class Answer < ApplicationRecord
  include LinkDependences

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def the_best!
    current_best = question.answers.find_by_best(true)
    transaction do
      current_best&.update!(best: false)
      update!(best: true)
      user.awards << question.award if question.award.present?
    end
  end
end
