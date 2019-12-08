class VotesController < ApplicationController
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy if current_user&.owner?(@vote)
  end
end
