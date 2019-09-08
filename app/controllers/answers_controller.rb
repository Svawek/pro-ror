class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  expose :question, ->{ Question.find(params[:question_id]) }
  expose :answer, scope: ->{ question.answers }
  expose :answers, ->{ question.answers }

  def create
    answer.user_id = current_user.id
    if answer.save
      @a_for_rspec = answer
      redirect_to question, notice: 'Your answer successfully created'
    else
      render 'questions/show'
    end
  end

  def destroy
    byebug
    if current_user.id == answer.user_id
      answer.destroy
      redirect_to questions_path, notice: 'Answer delete'
    else
      redirect_to questions_path, alert: "It is forbidden to delete someone else's answer"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
