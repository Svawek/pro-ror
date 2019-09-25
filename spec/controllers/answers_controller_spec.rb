require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  
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
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'deletes the answer by nonauthor' do
        login(user2)
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(0)
      end

      it 'render :destroy' do
        login(user)
        delete :destroy, params: { question_id: question, id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'for nonautheticated user' do
      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(0)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }
    before { login(user) }

    context 'with valid attributes' do
      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #select_best' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: user) }
    before do
      login(user)
      patch :select_best, params: { id: answer, answer: { best: true } }
    end

    it 'change answer.best to true' do
      best_answer = question.answers.select { |answer| answer.best == true }
      expect(best_answer.count).to eq 1
    end
    it 'change another answer.best to true' do
      patch :select_best, params: { id: answer2, answer: { best: true } }
      expect(answer.best).to be false
      best_answer = question.answers.select { |answer| answer.best == true }
      expect(best_answer.count).to eq 1
    end
    it 're-render question/show view' do
      expect(response).to render_template 'questions/show'
    end
  end
end
