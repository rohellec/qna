class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  expose :questions, -> { Question.all }
  expose :question

  def create
    if question.save
      flash[:success] = "New question has been succesfully created"
      redirect_to question
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_url
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
