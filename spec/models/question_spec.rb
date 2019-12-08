require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_one(:award).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it_behaves_like 'attached files', Question
  it_behaves_like 'check links in model'
  
  context 'check votes' do
    let!(:obj) { create(:question) }
    let!(:user) { create(:user) }

    it_should_behave_like 'check votes in model'
  end
end
