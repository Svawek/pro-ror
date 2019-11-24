require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  context 'Best answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:award) { create(:award, question: question) }

    it 'question do not have  best answers' do
      answer.the_best!
      expect(answer).to be_best
    end

    it 'question have best answer' do
      answer2 = create(:answer, :best, question: question, user: user)

      answer.the_best!
      answer2.reload

      expect(answer2).not_to be_best
      expect(answer).to be_best
    end

    it 'question do not have best answers with award' do
      answer.the_best!
      award.reload
      expect(award.user).to eq answer.user
    end
  end

  context 'Default scope' do
    let!(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }
    let!(:answer3) { create(:answer, :best, question: question) }

    it 'the best answer should be the first' do
      expect(question.answers).to eq [answer3, answer1, answer2]
    end
  end

  it_behaves_like 'attached files', Answer
  it_behaves_like 'check links in model'
end
