require 'rails_helper'

feature 'User can view questions', %q{
  In order to find some information
  I want to see all questions
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'User can view all questions' do
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
