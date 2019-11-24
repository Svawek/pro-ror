require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  describe "GET #destroy" do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }
    let!(:link) { create(:link, linkable: question) }
    context 'autheticated user' do
      it 'and author delete link' do
        login(author)
        expect { delete :destroy, params: { id: link}, format: :js }.to change(Link, :count).by(-1)
      end

      it 'and not author delete link' do
        login(user)
        expect { delete :destroy, params: { id: link}, format: :js }.to change(Link, :count).by(0)
      end

      it 'render :destroy when author login' do
        login(author)
        delete :destroy, params: { id: link}, format: :js
        expect(response).to render_template :destroy
      end

      it 'render :destroy when user login' do
        login(user)
        delete :destroy, params: { id: link}, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not authenticated user' do
      it 'and not author delete link' do
        expect { delete :destroy, params: { id: link}, format: :js }.to change(Link, :count).by(0)
      end

      it 'render :destroy' do
        delete :destroy, params: { id: link}, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

end
