class Vote < ApplicationRecord
  validates_inclusion_of :choice, in: [true, false]

  belongs_to :votable, polymorphic: true
  belongs_to :user

end
