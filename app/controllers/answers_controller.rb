class AnswersController < ApplicationController
  expose :question
  expose :answers, from: :question
  expose :answer, build: -> { answers.build(answer_params) }

  def create
    if answer.save
      redirect_to question
    else
      render "questions/show"
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer.question
    else
      render "questions/show"
    end
  end

  def destroy
    answer.destroy
    redirect_to answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
