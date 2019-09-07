require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  I'd like to be able to ask the question
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'ask a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test test'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'test test'
    end

    scenario 'ask a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthentocated user tries to ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
