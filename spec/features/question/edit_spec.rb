require 'rails_helper'

feature 'Author can edit question', %q{
  In order to correct mistakes in question
  To be authenticated user and author of this question
  I'd like to be able to correct the question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    scenario 'and author of question edit question', js: true do
      sign_in user
      visit questions_path

      click_on 'Edit'

      fill_in 'Title', with: 'Edited title'
      fill_in 'Body', with: 'Edited question'
      click_on 'Save'

      within '.questions' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited question'
      end
    end
    scenario 'and author of question edit question with errors'
    scenario 'and non-author of question try to edit question'

  end

  scenario 'Unauthenticated user try to edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end
