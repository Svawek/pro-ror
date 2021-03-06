require 'rails_helper'

feature 'Author can choose best answer', %q{
  In order to mark best answer
  To be authenticated user and author of the question
  I'd like to be able to choose best the answer
} do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user' do
    scenario 'and author of the question choose best answer', js: true do
      sign_in user
      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Best answer'

        expect(page).to have_text 'The author choose this answer the best:'
        expect(page).not_to have_button 'Best answer'
      end
    end

    scenario 'and non-author of the question choose best answer' do
      sign_in user2
      visit question_path(question)

      expect(page).not_to have_button 'Best answer'
    end
  end

  scenario 'Unauthenticated user try to choose best answer' do
    visit question_path(question)

    expect(page).not_to have_button 'Best answer'
  end

  scenario 'Only one best answer on the page' do
    create(:answer, :best, question: question)

    sign_in user
    visit question_path(question)

    expect(page).to have_text('The author choose this answer the best:', count: 1)
  end

  scenario 'The best answer is in the top' do
    create(:answer, :best, question: question)

    sign_in user
    visit question_path(question)

    expect(first('.answers>.answer')).to have_text('The author choose this answer the best:')
  end
end
