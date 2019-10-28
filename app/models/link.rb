class Link < ApplicationRecord
  validates :name, :url, presence: true
  validates :url, url: true

  belongs_to :linkable, polymorphic: true
end
