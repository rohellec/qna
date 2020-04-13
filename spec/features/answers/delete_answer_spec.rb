require "rails_helper"

feature "Author can delete his own answer", %(
  In order to remove wrong answer
  As answer's author
  I want to be able to delete it
) do

  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, author: user) }

  context "when author" do
    background do
      login user
      visit question_path(question)
      within(".answers") { click_on "Delete" }
    end

    scenario "answer is removed from question answers list with success message" do
      expect(page).to have_current_path(question_path(question))
      expect(page).to have_no_content(answer.body)
      expect(page).to have_content("Your answer has been successfully deleted")
    end
  end

  context "when not author" do
    let(:other_user) { create(:user) }

    background do
      login other_user
      visit question_path(question)
    end

    scenario "there is no link to delete other user's answer" do
      within ".answers" do
        expect(page).to have_no_content("Delete")
      end
    end
  end

  context "when not authenticated" do
    background { visit question_path(question) }

    scenario "there is no link to delete answer" do
      within ".answers" do
        expect(page).to have_no_content("Delete")
      end
    end
  end
end
