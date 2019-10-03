require 'rails_helper'

feature 'Author can edit answer', %q{
  In order to correct mistakes in answer
  To be authenticated user and author of this answer
  I'd like to be able to correct the answer
} do

  given!(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user' do
    scenario 'and author of answer edit answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit answer'
      within '.answers' do
        fill_in 'Your Answer', with: 'Correct answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Correct answer'
      end
    end
    scenario 'and author of answer edit answer with errors', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your Answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end
    end

    scenario 'and non-author of answer try to edit answer' do
      sign_in user2
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end

    scenario 'and author of answer edit answer and add files', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit answer'
      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/support/controller_helpers.rb", "#{Rails.root}/spec/support/feature_helpers.rb"]
        click_on 'Save'

        expect(page).to have_link 'controller_helpers.rb'
        expect(page).to have_link 'feature_helpers.rb'
      end
    end
  end

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end
end
