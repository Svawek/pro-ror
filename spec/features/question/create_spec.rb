require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  I'd like to be able to ask the question
} do
  scenario 'User ask a question' do
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test test'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'test test'
  end

  scenario 'User ask a question with errors'
end
