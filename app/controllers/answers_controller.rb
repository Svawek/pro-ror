class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: %i[update destroy select_best edit vote]
  before_action :load_answers, only: %i[update select_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.owner?(@answer)
  end

  def destroy
    @answer.destroy if current_user.owner?(@answer)
  end

  def select_best
    @answer.the_best! if current_user.owner?(@answer.question)
  end

  def vote
    unless @answer.vote?(current_user) || current_user.owner?(@answer)
      answer_vote = @answer.votes.new(choice: params[:choice], user: current_user)
      answer_vote.save
      redirect_to @answer.question, notice: 'Your vote counted'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], 
                                    links_attributes: [:name, :url])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_answers
    @answers = @answer.question.answers
  end
end
