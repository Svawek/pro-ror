require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }

  before { login(user) }

  describe "GET #index" do
    it 'render index view' do
      get :index

      expect(response).to render_template :index
    end
  end

end
