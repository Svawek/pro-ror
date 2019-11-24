require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Svawek/1fc1816264259cfa7c4e34ca19699aef' }
  given(:google_url) { 'https://www.google.ru/' }

  before do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'test_answer test_answer' 
  end

  scenario 'User adds one link when answers the question', js:true do
    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: google_url

    click_on 'Answer'
    visit question_path(question)
    within ('.answer.links')
    expect(page).to have_link 'Google', href: google_url
  end

  scenario 'User adds one link(gist) when answers the question', js:true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'
    visit question_path(question)
    
    expect(page).to have_link 'view raw', href: /#{gist_url}/
  end

  scenario 'User adds two links when answers the question', js:true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'add link'

    within find_all('.nested-fields')[1] do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url
    end

    click_on 'Answer'
    visit question_path(question)

    expect(page).to have_link 'view raw', href: /#{gist_url}/
    expect(page).to have_link 'Google', href: google_url
  end 

end
