require 'rails_helper'

feature 'Author can delete file from his question', %q{
  In order to have opportunity to delete files
  To be authenticated user and author of the question
  I can delete files from my question
} do
  given!(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, :with_file, user: user) }

  scenario 'Authenticated user delete file his own question', js: true do
    sign_in(user)
    find('a.view:first-child').click

    file_name = question.files.first.filename.to_s

    expect(page).to have_link file_name

    click_on 'Delete file'

    expect(page).to have_no_link file_name
  end

  scenario 'Authenticated user delete file not his question' do
    sign_in(user2)
    find('a.view:first-child').click

    expect(page).to have_no_button 'Delete file'
  end

  scenario 'Nonauthenticated user tries to delete file of the question' do
    visit questions_path
    find('a.view:first-child').click

    expect(page).to have_no_button 'Delete file'
  end
end
