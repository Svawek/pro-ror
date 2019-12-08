require 'rails_helper'

feature 'Authenticated user can vote for the question', %q{
  In order to vote for the question
  To be authenticated user
  I'd like to be able to vote for or against the question
} do

  given!(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    scenario 'vote for question', js: true do
      sign_in user
      visit question_path(question)

      within '.question-vote' do
        click_on "Like question"
        expect(page).to_not have_content "Like question"
        expect(page).to_not have_content "Dislike question"
        expect(page).to have_content "Vote result: 1"
        expect(page).to have_content "Cancel your vote"
      end
      expect(page).to have_text "Your vote counted"
    end
  end

  scenario 'Author of question vote for question' do
    sign_in author
    visit question_path(question)

    within '.question-vote' do
      expect(page).to_not have_content "Like question"
      expect(page).to_not have_content "Dislike question"
    end
  end

  scenario 'Non-authenticated user try to vote for question' do
    visit question_path(question)
    
    within '.question-vote' do
      expect(page).to_not have_content "Like question"
      expect(page).to_not have_content "Dislike question"
    end
  end
end
