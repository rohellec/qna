class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :redirect_if_not_author, only: %i[edit update destroy]

  expose :questions, -> { Question.all }
  expose :question
  expose :answer, -> { question.answers.build }

  def create
    question.author = current_user
    if question.save
      flash[:success] = "New question has been succesfully created"
      redirect_to question
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      flash[:success] = "Your question has been succesfully updated"
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    flash[:success] = "Your question has been successfully deleted"
    redirect_to questions_url
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
