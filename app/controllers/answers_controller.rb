class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  expose :question, ->{ Question.find(params[:question_id]) }
  expose :answer, scope: ->{ question.answers }
  expose :answers, ->{ question.answers }

  def create
    answer.user = current_user
    if answer.save
      redirect_to question, notice: 'Your answer successfully created'
    else
      render 'questions/show'
    end
  end

  def destroy
    unless current_user == answer.user
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
