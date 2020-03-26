require "rails_helper"

feature "Author can update his own answer", %(
  In order to have ability to clarify answer
  As answer's author
  I want to be able to update it after creation
) do

  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, author: user) }

  context "when answer's author" do
    background do
      login user
      visit question_path(question)
      within(".answers") { click_on "Edit" }
    end

    scenario "edit form for answer is shown instead of new answer form" do
      expect(page).to have_current_path(question_path(question, answer_id: answer.id))
      expect(page).to have_css(".edit-answer")
      expect(page).to have_content("Cancel")
      expect(page).to have_no_css(".new-answer")
    end

    scenario "after clicking Cancel link new answer form is shown" do
      click_on "Cancel"
      expect(page).to have_current_path(question_path(question))
      expect(page).to have_css(".new-answer")
      expect(page).to have_no_content("Cancel")
    end

    context "with valid attributes" do
      let(:answer_attributes) { attributes_for(:answer) }

      background do
        fill_in :answer_body, with: answer_attributes[:body]
        click_on "Update Answer"
      end

      scenario "answer is updated on question's answers list with success message" do
        expect(page).to have_current_path(question_path(question))
        expect(page).to have_content("Your answer has been successfully updated")
        expect(page).to have_content(answer_attributes[:body])
        expect(page).to have_no_content(answer.body)
        expect(page).to have_no_css(".edit-answer")
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { attributes_for(:answer, :invalid) }

      background do
        fill_in :answer_body, with: invalid_attributes[:body]
        click_on "Update Answer"
      end

      scenario "answer is not updated with error message" do
        expect(page).to have_content(answer.body)
        expect(page).to have_css(".edit-answer")
        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  context "when not author" do
    let(:other_user) { create(:user) }

    background do
      login other_user
      visit question_path(question)
    end

    scenario "there is no 'Edit' link for another user's answer" do
      within(".answers") do
        expect(page).to have_no_content("Edit")
      end
    end
  end

  context "when not authenticated" do
    background { visit question_path(question) }

    scenario "there is no 'Edit' link for answer" do
      within(".answers") do
        expect(page).to have_no_content("Edit")
      end
    end
  end
end
