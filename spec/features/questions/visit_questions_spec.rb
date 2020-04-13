require "rails_helper"

feature "User can visit questions page", %(
  In order to find interesting question
  As non-authenticated user
  I want to be able to visit questions page
) do

  context "when there are several questions" do
    let!(:questions) { create_list(:question, 10) }

    background { visit questions_path }

    scenario "list with question's titles is shown" do
      questions.each do |question|
        expect(page).to have_content(question.title)
        expect(page).to have_no_content(question.body)
        expect(page).to have_link("Show", href: question_path(question))
      end
    end
  end

  context "when there is no questions" do
    background { visit questions_path }

    scenario "message with info about empty questions list is shown" do
      expect(page).to have_content("Nobody has asked any question yet")
      expect(page).to have_no_content(".questions")
    end
  end
end
