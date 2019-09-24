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
    unless current_user.owner?(answer)
      redirect_to questions_path, alert: "It is forbidden to delete someone else's answer"
      return
    end

    answer.destroy
    redirect_to questions_path, notice: 'Answer delete'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
