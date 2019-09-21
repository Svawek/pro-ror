require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  
  describe 'GET #new' do
    before { login(user) }

    it 'render new view' do
      get :new, params: { question_id: question }

      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'for authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(Answer, :count).by(1)
        end
  
        it 'answer belong to question' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
          created_answer = Answer.order(created_at: :desc).first
          expect(created_answer.question).to eq question
        end
  
        it 'render template :create' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :create
        end
      end
  
      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
        end
  
        it 'render template :create' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'for nonauthenticated user' do
      let(:question) { create(:question) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change(Answer, :count)
      end
    
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'for authenticated user' do
      let(:user2) { create(:user) }
      
      it 'deletes the answer by author' do
        login(user)
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'deletes the answer by nonauthor' do
        login(user2)
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(0)
      end

      it 'redirect to index' do
        login(user)
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to questions_path
      end
    end

    context 'for nonautheticated user' do
      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(0)
      end
    end
  end
end
