class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_award
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
    @answer.links.new
  end

  def edit
    @question.links.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.owner?(@question)
  end

  def destroy
    unless current_user.owner?(@question)
      redirect_to questions_path, alert: "It is forbidden to delete someone else's question"
      return
    end

    @question.destroy
    redirect_to questions_path, notice: 'Question delete'
  end

  private

  def question_params
    params.require(:question).permit(
                                      :title, 
                                      :body, 
                                      files: [], 
                                      links_attributes: [:name, :url],
                                      award_attributes: [:title, :image]
                                    )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
