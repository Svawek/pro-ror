module Votable
  extend ActiveSupport::Concern
  
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def user_vote_obj(user)
    user_vote_hash(user).first
  end

  def vote?(user)
    user_vote_hash(user).present?
  end

  private

  def user_vote_hash(user)
    self.votes.where(user_id: user.id)
  end
end
