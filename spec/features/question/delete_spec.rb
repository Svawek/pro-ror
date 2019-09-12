require 'rails_helper'

feature 'Author can delete his question', %q{
  In order to have opportunity to delete question
  To be authenticated user and author of this question
  I can delete my question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user delete his own question' do
    sign_in(user)
    find('a.view:first-child').click

    click_on 'Delete'

    expect(page).to have_no_text question.body
  end

  scenario 'Authenticated user delete not his question' do
    sign_in(user2)
    find('a.view:first-child').click

    click_on 'Delete'

    expect(page).to have_content "It is forbidden to delete someone else's question"
  end

  scenario 'Nonauthenticated user tries to delete the question' do
    visit questions_path
    find('a.view:first-child').click

    expect(page).to have_no_button 'Delete Answer'
  end
end
