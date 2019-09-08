require 'rails_helper'

feature 'Author can delete his answer', %q{
  In order to have opportunity to delete answer
  To be authenticated user and author of this answer
  I can delete my answer
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

    fill_in 'Body', with: 'test_answer test_answer'
    click_on 'Answer'
  end

  scenario 'Authenticated user delete his own answer' do
    click_on 'Delete Answer'

    expect(page).to have_content 'Answer delete'
  end

  scenario 'Authenticated user delete not his answer' do
    click_on 'Sign out'

    sign_in(user2)
    find('table tr:first-child a.view').click

    click_on 'Delete Answer'

    expect(page).to have_content "It is forbidden to delete someone else's answer"
  end

  scenario 'Nonauthenticated user tries to delete the answer' do
    click_on 'Sign out'

    find('table tr:first-child a.view').click

    click_on 'Delete Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
