class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  expose :question, id: ->{ params[:question_id] || Answer.find(params[:id]).question.id }
  expose :answer, scope: ->{ question.answers }
  expose :answers, ->{ question.answers }

  def create
    answer.user = current_user
    answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy if current_user.owner?(answer)
  end

  def select_best
    answer.the_best if current_user.owner?(answer)
    redirect_to question_path(question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
