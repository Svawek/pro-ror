require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unregistered user
  I'd like to sign up
} do
  before { visit new_user_registration_path }

  scenario 'Unregistered user sign up' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user type wrong password confirmation' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '87654321'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match"
  end

  scenario 'Unregistered user sign up and miss password' do
    fill_in 'Email', with: 'user@test.com'
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Unregistered user sign up and miss email' do
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
