require 'rails_helper'

feature 'Author can delete his answer', %q{
  In order to have opportunity to delete answer
  To be authenticated user and author of this answer
  I can delete my answer
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user delete his own answer' do
    sign_in(user)
    find('a.view:first-child').click
    click_on 'Delete Answer'

    expect(page).to have_no_text answer.body
  end

  scenario 'Authenticated user delete not his answer' do
    sign_in(user2)
    find('a.view:first-child').click

    click_on 'Delete Answer'

    expect(page).to have_content "It is forbidden to delete someone else's answer"
  end

  scenario 'Nonauthenticated user tries to delete the answer' do
    visit questions_path
    find('a.view:first-child').click

    expect(page).to have_no_button 'Delete Answer'
  end
end
