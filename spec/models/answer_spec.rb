require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  context 'Best answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: user) }

    it 'question do not have  best answers' do
      answer.the_best
      expect(answer).to be_best
    end

    it 'question have best answer' do
      answer.the_best
      answer2.the_best
      expect(answer).not_to be_best
      expect(answer2).to be_best
    end
  end
end
