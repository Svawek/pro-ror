class QuestionsController < ApplicationController
  expose :questions, ->{ Question.all }
  expose :question
end
