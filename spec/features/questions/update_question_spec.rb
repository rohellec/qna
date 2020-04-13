require "rails_helper"

feature "Author can update his own question", %(
  In order to have ability to clarify question
  As question's author
  I want to be able to update it after creation
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  context "when question's author" do
    background do
      login user
      visit question_path(question)
      click_on "Edit"
    end

    context "with valid attributes" do
      given(:question_attributes) { attributes_for(:question) }

      background do
        fill_in :question_title, with: question_attributes[:title]
        fill_in :question_body,  with: question_attributes[:body]
        click_on "Update Question"
      end

      scenario "question is updated with success message" do
        expect(page).to have_current_path(question_path(question))
        expect(page).to have_content(question_attributes[:title])
        expect(page).to have_content(question_attributes[:body])
        expect(page).to have_content("Your question has been succesfully updated")
      end
    end

    context "with invalid attributes" do
      given(:invalid_attributes) { attributes_for(:question, :invalid) }

      background do
        fill_in :question_title, with: invalid_attributes[:title]
        fill_in :question_body,  with: invalid_attributes[:body]
        click_on "Update Question"
      end

      scenario "question is not updated with errors" do
        expect(page).to have_content("Edit question")
        expect(page).to have_content("Title can't be blank")
      end
    end
  end

  context "when not author" do
    given(:other_user) { create(:user) }

    background { login(other_user) }

    context "when visiting other user's question" do
      background { visit question_path(question) }

      scenario "there is no link to edit question" do
        expect(page).to have_no_content("Edit")
      end
    end

    context "when visiting questions page" do
      background { visit questions_path }

      scenario "there is no link to edit question" do
        within(".questions") do
          expect(page).to have_no_content("Edit")
        end
      end
    end

    context "when trying to access edit question page" do
      background { visit edit_question_path(question) }

      scenario "redirected to home page with message" do
        expect(page).to have_current_path(root_path)
        expect(page).to have_content("You need to be an author of question")
      end
    end
  end

  context "when not authenticated" do
    context "when visiting question page" do
      background { visit question_path(question) }

      scenario "there is no link to edit question" do
        expect(page).to have_no_content("Edit")
      end
    end

    context "when visiting questions page" do
      background { visit questions_path }

      scenario "there is no link to edit question" do
        within(".questions") do
          expect(page).to have_no_content("Edit")
        end
      end
    end

    context "when trying to access edit question page" do
      background { visit edit_question_path(question) }

      scenario "redirected to home page with message" do
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content(I18n.t("devise.failure.unauthenticated"))
      end
    end
  end
end
