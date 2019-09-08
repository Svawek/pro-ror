require 'rails_helper'

feature 'Author can delete his question', %q{
  In order to have opportunity to delete question
  To be authenticated user and author of this question
  I can delete my question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  background do 
    sign_in(user) 
    visit questions_path

    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test test'
    click_on 'Ask'
  end

  scenario 'Authenticated user delete his own question' do
    click_on 'Delete'

    expect(page).to have_content 'Question delete'
  end

  scenario 'Authenticated user delete not his question' do
    click_on 'Sign out'

    sign_in(user2)
    find('table tr:first-child a.view').click

    click_on 'Delete'

    expect(page).to have_content "It is forbidden to delete someone else's question"
  end

  scenario 'Nonauthenticated user tries to delete the question' do
    click_on 'Sign out'

    find('table tr:first-child a.view').click

    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
