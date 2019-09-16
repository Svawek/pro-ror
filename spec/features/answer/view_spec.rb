require 'rails_helper'

feature 'User can view answers', %q{
  In order to find right answer
  I want to see all answer
  On question page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  
  scenario 'User can view all answers' do
    visit questions_path
    find('a.view:first-child').click

    expect(page).to have_content answer.body
  end
end
