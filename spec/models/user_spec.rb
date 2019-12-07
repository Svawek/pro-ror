require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :awards }
   
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  context 'Owner of answer' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer) }
    let(:current_user) { nil }

    it 'author' do
      expect(question.user).to be_owner(question)
    end

    it 'nonauthor' do
      expect(answer.user).not_to be_owner(question)
    end

    it 'nonauthenticated user' do
      expect(current_user&.owner?(question)).to be_falsy
    end
  end
end
