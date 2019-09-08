require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  before { login(user) }
  
  describe 'GET #new' do
    it 'render new view' do
      get :new, params: { question_id: question }

      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'answer belong to question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:a_for_rspec).question.id).to eq question.id
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user_id: user.id) }
    let!(:answer) { create(:answer, question_id: question.id) }
    before { login(user) }
    
    it 'deletes the answer by author' do
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'deletes the answer by nonauthor' do
      sign_out(user)
      user2 = FactoryBot.create(:user)
      sign_in(user2)
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(0)
    end

    it 'redirect to index' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to redirect_to questions_path
    end
  end
end
