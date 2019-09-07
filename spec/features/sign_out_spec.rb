require 'rails_helper'

feature 'Authenticated user can sign out', %q{
  As an authenticated user
  I'd like to sign out
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user sign out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end