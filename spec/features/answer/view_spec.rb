require 'rails_helper'

feature 'User can view answers', %q{
  In order to find right answer
  I want to see all answer
  On question page
} do
  given!(:question) { create(:question) }
  given(:user) { create(:user) }
  background do
    sign_in(user)

    visit questions_path
    find('table tr:first-child a.view').click

    fill_in 'Body', with: 'test_answer test_answer'
    click_on 'Answer'

    fill_in 'Body', with: 'test_answer2 test_answer2'
    click_on 'Answer'

    click_on 'Sign out'
  end

  scenario 'User can view all answers' do
    visit questions_path
    find('table tr:first-child a.view').click

    expect(page).to have_content 'test_answer test_answer'
    expect(page).to have_content 'test_answer2 test_answer2'
  end
end
