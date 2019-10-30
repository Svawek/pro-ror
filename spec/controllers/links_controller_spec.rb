require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  describe "GET #destroy" do
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let!(:link) { create(:link, linkable: question) }
    context 'autheticated user' do
      it 'and author delete link' do
        login(:author)
        expect { delete :destroy, params: { id: link.id} }.to change(Link, :count).by(-1)
      end
    end
  end

end
