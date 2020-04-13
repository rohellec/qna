require "rails_helper"

feature "User can delete his questions", %(
  In order to remove inappropriate question
  As question's author
  I want to be able to delete it
) do

  given(:user) { create(:user) }
  given!(:user_question)  { create(:question, author: user) }
  given!(:other_question) { create(:question) }

  context "when authenticated" do
    background { login(user) }

    context "when on questions page" do
      background { visit questions_path }

      scenario "there is a link to delete user's question" do
        within "#question-#{user_question.id}" do
          expect(page).to have_link("Delete", href: question_path(user_question))
        end
      end

      scenario "there is no link to delete other user's question" do
        within "#question-#{other_question.id}" do
          expect(page).to have_no_link("Delete")
        end
      end

      context "after clicking on delete link" do
        background { click_on "Delete" }

        scenario "question is removed with success message" do
          expect(page).to have_no_css("question-#{user_question.id}")
        end
      end
    end

    context "when on user's question show page" do
      background { visit question_path(user_question) }

      scenario "there is a link to delete a question" do
        expect(page).to have_content("Delete")
      end

      context "after clicking on delete link" do
        background { click_on "Delete" }

        scenario "question is removed with success message" do
          expect(page).to have_current_path(questions_path)
          expect(page).to have_content("Your question has been successfully deleted")
          expect(page).to have_no_css("question-#{user_question.id}")
        end
      end
    end

    context "when on other user's question show page" do
      background { visit question_path(other_question) }

      scenario "there is no delete link" do
        expect(page).to have_no_content("Delete")
      end
    end
  end

  context "when not authenticated" do
    context "when on questions page" do
      background { visit questions_path }

      scenario "there is no delete link" do
        expect(page).to have_no_content("Delete")
      end
    end

    context "when on question's show page" do
      background { visit question_path(user_question) }

      scenario "there is no delete link" do
        expect(page).to have_no_content("Delete")
      end
    end
  end
end
