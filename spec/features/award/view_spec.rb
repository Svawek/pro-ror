require 'rails_helper'

feature 'User can view his awards', %q{
  In order to have opportunity to view awards
  To be authenticated user 
  I can view my awards
} do
  given!(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:award) { create(:award, question: question, user: user) }

  scenario 'Authenticated user view his awards' do
    link = rails_blob_path(user.awards.first.image, only_path: true)
    sign_in(user)
    visit awards_path

    expect(page).to have_text question.title
    expect(page).to have_css "img[src*='#{link}']"
    expect(page).to have_text award.title
  end

  scenario 'Another user try to view awards' do
    link = rails_blob_path(user.awards.first.image, only_path: true)
    sign_in(user2)
    visit awards_path

    expect(page).to have_no_text question.title
    expect(page).to have_no_css "img[src*='#{link}']"
    expect(page).to have_no_text award.title
  end

  scenario 'Guest try to view awards' do
    visit awards_path

    expect(page).to have_no_text award.title
    expect(page).to have_text "Sign in"
  end

end
