class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, ->{ Question.all }
  expose :question
  expose :answer, ->{ answers.new }
  expose :answers, ->{ question.answers }

  def create
    question.user_id = current_user.id
    if question.save
      @q_for_rspec = question
      redirect_to question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def show
    #@answers = question.answers
    #@answer = @answers.new
  end

  def destroy
    if current_user.id == question.user_id
      question.destroy
      redirect_to questions_path, notice: 'Question delete'
    else
      redirect_to questions_path, alert: "It is forbidden to delete someone else's question"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
