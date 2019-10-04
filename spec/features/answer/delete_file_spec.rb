require 'rails_helper'

feature 'Author can delete his files in the answer', %q{
  In order to have opportunity to delete files in the answer
  To be authenticated user and author of this answer
  I can delete files in my answer
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, :with_file, question: question, user: user) }

  scenario 'Authenticated user delete his own files in his answer', js: true do
    sign_in(user)
    find('a.view:first-child').click
    file_name = answer.files.first.filename.to_s

    expect(page).to have_link file_name
    click_on 'Delete file'

    expect(page).to have_no_link file_name
  end

  scenario 'Authenticated user delete files in not his answer' do
    sign_in(user2)
    find('a.view:first-child').click

    expect(page).to have_no_button 'Delete file'
  end

  scenario 'Nonauthenticated user tries to delete files in the answer' do
    visit questions_path
    find('a.view:first-child').click

    expect(page).to have_no_button 'Delete file'
  end
end
