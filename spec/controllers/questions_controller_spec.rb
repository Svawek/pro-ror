require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    it 'render index view' do
      get :index

      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'render show view' do
      question = FactoryBot.create(:question)
      get :show, params: { id: question }

      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'render new view' do
      get :new

      expect(response).to render_template :new
    end
  end
end
