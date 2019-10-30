require 'rails_helper'

feature 'Author can delete his link', %q{
  In order to have opportunity to delete link
  To be authenticated user and author of this link
  I can delete my link
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:link) { create(:link, linkable_type: Question, linkable_id: question.id) }

  scenario 'Authenticated user delete his own link' do
    sign_in(author)
    visit question_path(question)

    expect(page).to have_text link.name

    click_on 'Delete link'

    expect(page).to have_no_text link.name
  end

end
