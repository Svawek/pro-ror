class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, ->{ Question.all }
  expose :question
  expose :answer, ->{ answers.new }
  expose :answers, ->{ question.answers }

  def create
    question.user = current_user
    if question.save
      redirect_to question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    unless current_user.owner?(question)
      redirect_to questions_path, alert: "It is forbidden to delete someone else's question"
      return
    end

    question.destroy
    redirect_to questions_path, notice: 'Question delete'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
