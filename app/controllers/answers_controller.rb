class AnswersController < ApplicationController
  before_action :redirect_if_not_author, only: %i[update destroy]

  expose :question
  expose :answers, from: :question
  expose :answer, build: -> { answers.build(answer_params) }

  def create
    answer.author = current_user
    if answer.save
      flash[:success] = "New answer has been successfully created"
      redirect_to question
    else
      render "questions/show"
    end
  end

  def update
    if answer.update(answer_params)
      flash[:success] = "Your answer has been successfully updated"
      redirect_to answer.question
    else
      render "questions/show"
    end
  end

  def destroy
    answer.destroy
    flash[:success] = "Your answer has been successfully deleted"
    redirect_to answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
