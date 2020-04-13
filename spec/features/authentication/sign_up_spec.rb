require "rails_helper"

feature "User can sign up", %(
  In order to have ability to sign in to the app
  As non-authenticated user
  I want to be able to sign up into the application
) do

  background { sign_up(auth_attributes) }

  context "With valid attributes" do
    let(:auth_attributes) { attributes_for(:user) }

    scenario "user is succesfully signed up" do
      expect(page).to have_current_path(root_path)
      expect(page).to have_content(I18n.t("devise.registrations.signed_up"), count: 1)
    end
  end

  context "With invalid attributes" do
    let(:auth_attributes) { attributes_for(:user, :invalid) }

    scenario "user stays unauthenticated with errors" do
      expect(page).to have_content "Sign up"
      expect(page).to have_content(I18n.t("errors.messages.not_saved",
                                          count: 2,
                                          resource: User.model_name.human.downcase))
    end
  end
end
