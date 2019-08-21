class AnswersController < ApplicationController
  expose :answers, ->{ Answer.all }
  expose :answer
end
