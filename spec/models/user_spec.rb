require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
   
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  context 'Owner of answer' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer) }
    let(:current_user) { nil }

    it 'author' do
      expect(question.user.owner?(question)).to be_truthy
    end

    it 'nonauthor' do
      expect(answer.user.owner?(question)).to be_falsy
    end

    it 'nonauthenticated user' do
      expect(current_user&.owner?(question)).to be_falsy
    end
  end
end
