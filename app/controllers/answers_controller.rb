class AnswersController < ApplicationController
  expose :question, ->{ Question.find(params[:question_id]) }
  expose :answer

  def new
    @answer = question.answers.new(answer_params)
  end

  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to question, notice: 'Your answer successfully created'
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
