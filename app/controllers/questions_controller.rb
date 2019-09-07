class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  expose :questions, ->{ Question.all }
  expose :question
  expose :answer, ->{ question.answers.new }
  expose :answers, ->{ question.answers }

  def create
    if question.save
      @q_for_rspec = question
      redirect_to question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
