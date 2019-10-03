require 'rails_helper'

feature 'User can answer the question', %q{
  In order to help another user
  I want to answer the question
} do
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    background do
      sign_in(user)

      visit questions_path
      find('a.view:first-child').click
    end

    scenario 'answer the question', js: true do
      fill_in 'Body', with: 'test_answer test_answer'
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_content 'test_answer test_answer'
      end
    end

    scenario 'answer the question with error', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthentocated user tries to answer the question' do
    visit questions_path
    find('a.view:first-child').click

    expect(page).to have_no_button 'Answer'
  end
end
