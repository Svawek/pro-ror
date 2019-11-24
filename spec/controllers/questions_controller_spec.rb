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
    before { get :show, params: { id: question } }

    it 'render show view' do
      expect(response).to render_template :show
    end

    it 'assigns new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end    
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns new Award for @question' do
      expect(assigns(:question).award).to be_a_new(Award)
    end 

    it 'render new view' do
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

        it 'saves a new link in the database' do
          expect { post :create, params: { question: attributes_for(:question, "links_attributes"=>{"0"=>{"name"=>"vk", "url"=>"https://vk.com", "_destroy"=>"false"}}) } }.to change(Link, :count).by(1)
        end

        it 'saves a new award in the database' do
          expect { post :create, params: { question: attributes_for(:question, "award_attributes"=>{"title"=>"1", "image"=> fixture_file_upload('award.webp', 'image/webp') }) } }.to change(Award, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to Question.order(created_at: :desc).first
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 'does not save a new link in the database' do
          expect { post :create, params: { question: attributes_for(:question, "links_attributes"=>{"0"=>{"name"=>"vk", "url"=>"vk.com", "_destroy"=>"false"}}) } }.to change(Link, :count).by(0)
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
        login(user2)
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

  describe 'PATCH #update' do
    context 'Author' do
      before { login(user) }

      context 'with valid attributes' do
        it 'change question attributes' do
          patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
          question.reload
          expect(question.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change attributes' do
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          end.to_not change(question, :title)
        end

        it 'render update view' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Non-author' do
      let(:user2) { create(:user) }
      before { login(user2) }

      it 'do not change question attributes' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to_not eq 'new body'
      end
    end

    context 'Guest' do
      it 'do not change question attributes' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to_not eq 'new body'
      end
    end
  end


end
