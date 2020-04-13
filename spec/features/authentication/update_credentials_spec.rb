require "rails_helper"

feature "User can update his credentials", %(
  In order to update my info
  As authenticated user
  I want to be able to change my credentials
) do

  given(:user) { create(:user) }

  context "when authenticated" do
    background { login(user) }

    context "when trying to update its own info" do
      background { visit edit_user_registration_path }

      context "with valid attributes" do
        given(:valid_attributes) { attributes_for(:user) }

        background do
          fill_in :user_email, with: valid_attributes[:email]
          fill_in :user_current_password, with: user.password
          click_on "Update"
        end

        scenario "user redirected with success message" do
          expect(page).to have_current_path(root_path)
          expect(page).to have_content(I18n.t("devise.registrations.updated"))
        end

        scenario "user email is updated on credentials page" do
          visit edit_user_registration_path
          expect(page).to have_field("user_email", with: valid_attributes[:email])
        end
      end

      context "with invalid attribures" do
        given(:invalid_user) { attributes_for(:user, :invalid) }

        background do
          fill_in :user_email, with: invalid_user[:email]
          fill_in :user_current_password, with: user.password
          click_on "Update"
        end

        scenario "user credentials are not updated with error" do
          expect(page).to have_content("Edit User")
          expect(page).to have_content("Email can't be blank")
        end
      end
    end
  end

  context "when not authenticated and trying to access update credentials page" do
    background { visit  edit_user_registration_path }

    scenario "user is redirected to root page with error message" do
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content(I18n.t("devise.failure.unauthenticated"))
    end
  end
end
