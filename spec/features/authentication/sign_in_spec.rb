require  "rails_helper"

feature "User can sign in", %(
  In order to have ability to create questions or answers
  As non-signed in user
  I want to be able to sign in to the application
) do

  context "with valid attributes" do
    context "when user is registered" do
      given(:user) { create(:user) }

      background { login(user) }

      scenario "user is succesfully signed in" do
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t("devise.sessions.signed_in"), count: 1)
      end

      context "after authentication" do
        background { click_on "Sign out" }

        scenario "user is able to sign out" do
          expect(page).to have_content(I18n.t("devise.sessions.signed_out"))
          expect(page).to have_link("Sign in")
          expect(page).to have_no_link("Sign out")
        end
      end
    end

    context "when user is not registered" do
      given(:user) { build(:user) }

      background { login(user) }

      scenario "user stays non-signed in with errors" do
        expect(page).to have_content "Sign in"
        expect(page).to have_content(I18n.t("devise.failure.invalid", authentication_keys: "Email"))
      end
    end
  end

  context "with invalid atributes" do
    given(:user) { build(:user, :invalid) }

    background { login(user) }

    scenario "user stays non-signed in with errors" do
      expect(page).to have_content "Sign in"
      expect(page).to have_content(I18n.t("devise.failure.invalid", authentication_keys: "Email"))
    end
  end

  context "when user is already signed in" do
    given(:user) { create(:user) }

    background do
      login(user)
      visit sign_in_path
    end

    scenario "user is not allowed visit sign in page with error" do
      expect(page).to have_current_path(root_path)
      expect(page).to have_content(I18n.t("devise.failure.already_authenticated"))
    end
  end
end
