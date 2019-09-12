require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    it 'render index view' do
      get :index

      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'render show view' do
      get :show, params: { id: :question }

      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    it 'render new view' do
      get :new

      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'for authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to Question.last
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'for nonauthenticated user' do
      it 'does not save the answer' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user2) { create(:user) }
    let!(:question) { create(:question, user: user) }
    

    context 'for authenticated user' do
      it 'deletes the question by author' do
        login(user)
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end
  
      it 'deletes the question by nonauthor' do
        login(user2)
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end
  
      it 'redirect to index' do
        login(user)
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'for nonautheticated user' do
      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end
    end
  end
end
