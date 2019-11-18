class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def the_best!
    current_best = question.answers.find_by_best(true)
    transaction do
      current_best&.update!(best: false)
      update!(best: true)
      user.awards << question.awards if question.awards.present?
    end
  end
end
