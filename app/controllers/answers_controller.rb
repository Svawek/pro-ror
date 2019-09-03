class AnswersController < ApplicationController
  expose :question, ->{ Question.find(params[:question_id]) }
  expose :answer, ->{ question.answers.new(answer_params) }
  expose :answers, ->{ question.answers.all }

  def create
    if answer.save
      redirect_to question, notice: 'Your answer successfully created'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
