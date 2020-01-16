require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }

  describe "GET #index" do
    let(:answers)  { create_list(:answer, 3, question: question) }

    before do
      get :index, params: { question_id: question }
    end

    it "assigns the answered question to a variable" do
      expect(assigns(:question)).to eq(question)
    end

    it "assigns array of answers to a variable" do
      expect(assigns(:answers)).to match_array(answers)
    end

    it "renders :index view" do
      expect(response).to render_template(:index)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_params) { attributes_for(:answer, question: question) }

      it "creates new answer for question" do
        expect do
          post :create, params: { question_id: question, answer: valid_params }
        end.to change(question.answers, :count).by(1)
      end

      it "params equal to created answer attributes" do
        post :create, params: { question_id: question, answer: valid_params }
        expect(assigns(:answer).body).to eq(valid_params[:body])
      end

      it "redirects to question" do
        post :create, params: { question_id: question, answer: valid_params }
        expect(response).to redirect_to(question)
      end
    end

    context "with invalid params" do
      let(:invalid_params) { attributes_for(:answer, :invalid, question: question) }

      it "doesn't add new answer for question" do
        expect do
          post :create, params: { question_id: question, answer: invalid_params }
        end.not_to change(Answer, :count)
      end

      it "renders question's :show view" do
        post :create, params: { question_id: question, answer: invalid_params }
        expect(response).to render_template("questions/show")
      end
    end
  end

  describe "PATCH #update" do
    let(:answer) { create(:answer, question: question) }

    before do
      patch :update, params: { id: answer, answer: answer_params }
    end

    context "with valid params" do
      let(:answer_params) { attributes_for(:answer, question: question) }

      it "updates answer with given params" do
        answer.reload
        expect(answer.body).to eq(answer_params[:body])
      end

      it "redirects to show" do
        expect(response).to redirect_to(question)
      end
    end

    context "with invalid params" do
      let(:answer_params) { attributes_for(:answer, :invalid, question: question) }

      it "doesn't update answer attributes" do
        requested_answer = assigns(:answer)
        requested_answer.reload
        expect(requested_answer.body).to eq(answer.body)
      end

      it "renders question's :show view" do
        expect(response).to render_template("questions/show")
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:answer) { create(:answer, question: question) }

    it "deletes the answer" do
      expect do
        delete :destroy, params: { id: answer }
      end.to change(Answer, :count).by(-1)
    end

    it "redirects to question" do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to(question)
    end
  end
end
