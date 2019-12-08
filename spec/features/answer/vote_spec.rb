require 'rails_helper'

feature 'Authenticated user can vote for the answer', %q{
  In order to vote for the answer
  To be authenticated user
  I'd like to be able to vote for or against the answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user' do
    scenario 'vote for answer', js: true do
      sign_in user
      visit question_path(question)

      within '.answer-vote' do
        click_on "Like answer"
        expect(page).to_not have_content "Like answer"
        expect(page).to_not have_content "Dislike answer"
        expect(page).to have_content "Vote result: 1"
        expect(page).to have_content "Cancel your vote"
      end
      expect(page).to have_text "Your vote counted"
    end
  end

  scenario 'Author of answer vote for answer' do
    sign_in author
    visit question_path(question)

    within '.answer-vote' do
      expect(page).to_not have_content "Like answer"
      expect(page).to_not have_content "Dislike answer"
    end
  end

  scenario 'Non-authenticated user try to vote for answer' do
    visit question_path(question)
    
    within '.answer-vote' do
      expect(page).to_not have_content "Like answer"
      expect(page).to_not have_content "Dislike answer"
    end
  end
end
