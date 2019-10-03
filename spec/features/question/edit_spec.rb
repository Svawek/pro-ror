require 'rails_helper'

feature 'Author can edit question', %q{
  In order to correct mistakes in question
  To be authenticated user and author of this question
  I'd like to be able to correct the question
} do

  given!(:user) { create(:user) }
  given(:user2) { create(:user) }
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
    scenario 'and author of question edit question with errors', js: true do
      sign_in user
      visit questions_path

      click_on 'Edit'

      fill_in 'Body', with: ''
      click_on 'Save'

      within '.questions' do
        expect(page).to have_content question.body
      end
    end

    scenario 'and non-author of question try to edit question' do
      sign_in user2
      visit questions_path

      expect(page).to_not have_link 'Edit'
    end

    scenario 'and author edit question with attaching files', js: true do
      sign_in user
      visit questions_path

      click_on 'Edit'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Save'

      within '.questions' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user try to edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end
