class AnswersController < ApplicationController
  expose :question, ->{ Question.find(params[:question_id]) }
  expose :answer

  def new
    @answer = Answer.new
  end

  def create
    @answer = question.answers.new(answer_params)
    @answers = question.answers
    if @answer.save
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
