require "rails_helper"

feature "User can sign out", %(
  In order to close session with application
  As authenticates user
  I want to be able to sign out
) do

  given(:user) { create(:user) }

  background { visit root_path }

  context "when authenticated" do
    background { login(user) }

    scenario "sign out link is visible in the header" do
      expect(page).to have_content("Sign out")
    end

    context "after clicking on 'Sign out' link" do
      background { click_on "Sign out" }

      scenario "user is signed out from the application" do
        expect(page).to have_content("Sign in")
        expect(page).to have_no_content("Sign out")
      end
    end
  end

  context "when not authenticated" do
    scenario "there is no 'Sign out' link on the page" do
      expect(page).to have_content("Sign in")
      expect(page).to have_no_content("Sign out")
    end
  end
end
