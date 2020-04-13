require "rails_helper"

feature "User can visit question page", %(
  In order to find answer for interesting question
  As non-authenticated user
  I want to be able to visit question page
) do

  let(:question) { create(:question) }

  background { visit question_path(question) }

  scenario "there is question's title and body rendered on the page" do
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
  end

  context "when there are answers for the question" do
    let!(:answers) { create_list(:answer, 5, question: question) }

    background { visit question_path(question) }

    scenario "list of answers bodies is rendered on the page" do
      answers.each { |answer| expect(page).to have_content(answer.body) }
    end
  end

  context "when there is no answers" do
    let!(:answers) { create_list(:answer, 5, question: question) }

    scenario "message with info about empty answers list is shown" do
      expect(page).to have_content("Nobody has given any answer yet")
    end
  end
end
