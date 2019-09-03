require 'rails_helper'

feature 'User can answer the question', %q{
  In order to help another user
  I want to answer the question
} do
  given!(:question) { create(:question) }

  scenario 'User answer the question' do
    visit questions_path
    find('table tr:first-child a.view').click

    fill_in 'Body', with: 'test_answer test_answer'
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'test_answer test_answer'
  end

  scenario 'User answer the question with error' do
    visit questions_path
    find('table tr:first-child a.view').click

    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end
end
