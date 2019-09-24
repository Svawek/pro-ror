class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def the_best
    question = self.question
    question.answers.each do |answer|
      if answer.best
        answer.best = false
        return
      end
    end

    self.best = true
  end
end
