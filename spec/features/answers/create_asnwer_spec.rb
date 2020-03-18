require "rails_helper"

feature "Authenticated user can create answer for question", %(
  In order to help community to resolve issues
  As authenticated user
  I want to be able to create answers
) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context "when authenticated" do
    background do
      login user
      visit question_path(question)
    end

    context "when filling answer's body" do
      let(:answer_attrs) { attributes_for(:answer) }

      background do
        fill_in :answer_body, with: answer_attrs[:body]
        click_on "Create Answer"
      end

      scenario "new answer appears on question page with message" do
        expect(page).to have_current_path(question_path(question))
        expect(page).to have_content(answer_attrs[:body])
        expect(page).to have_content("New answer has been successfully created")
      end
    end

    context "without filling answer's body" do
      background do
        click_on "Create Answer"
      end

      scenario "answer is not created with errors" do
        expect(page).to have_content(question.title)
        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  context "when not authenticated" do
    background { visit question_path(question) }

    scenario "new answer form is not present on question's page" do
      expect(page).to have_current_path(question_path(question))
      expect(page).to have_no_content(".new-answer")
      expect(page).to have_no_content("Create Answer")
    end
  end
end
