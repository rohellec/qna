require "rails_helper"

feature "Authenticated user can create questions", %(
  In order to have ability to ask community for help
  As authenticated user
  I want to be able to create questions
) do

  let(:user) { create(:user) }

  context "when authenticated" do
    background do
      login(user)
      visit questions_path
      click_on "Ask a question"
    end

    context "with filled mandatory fields" do
      let(:question_attrs) { attributes_for(:question) }

      background do
        fill_in :question_title, with: question_attrs[:title]
        fill_in :question_body,  with: question_attrs[:body]
        click_on "Create Question"
      end

      scenario "redirected to created question with success message" do
        expect(page).to have_current_path(question_path(Question.last))
        expect(page).to have_content(question_attrs[:title])
        expect(page).to have_content(question_attrs[:body])
        expect(page).to have_content("New question has been succesfully created")
      end
    end

    context "without filled mandatory fields" do
      background { click_on "Create Question" }

      scenario "question is not created with errors" do
        expect(page).to have_content("New question")
        expect(page).to have_content("Body can't be blank")
        expect(page).to have_content("Title can't be blank")
      end
    end
  end

  context "when not authenticated" do
    context "when visiting questions page" do
      background { visit questions_path }

      scenario "there is no link to create question" do
        expect(page).not_to have_link("Ask a question")
      end
    end

    context "when trying to access new question page" do
      background { visit new_question_path }

      scenario "redirected sign in page with message" do
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content(I18n.t("devise.failure.unauthenticated"))
      end
    end
  end
end
