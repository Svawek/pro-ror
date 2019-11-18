class Award < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :title, :link, presence: true

end
