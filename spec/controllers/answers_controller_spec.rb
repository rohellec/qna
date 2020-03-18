require 'rails_helper'

shared_examples "non-author request" do
  context do
    it { is_expected.to set_flash[:danger] }
    it { is_expected.to redirect_to(root_url) }
  end
end

describe AnswersController do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "POST #create" do
    let(:answer_params) { attributes_for(:answer, question: question) }

    context "when authenticated" do
      before { sign_in(user) }

      context "with valid params" do
        let(:answer) { question.answers.last }

        it "creates new answer for question" do
          expect do
            post :create, params: { question_id: question, answer: answer_params }
          end.to change(question.answers, :count).by(1)
        end

        it "params equal to created answer attributes" do
          post :create, params: { question_id: question, answer: answer_params }
          expect(answer.body).to eq(answer_params[:body])
        end

        it "redirects to question" do
          post :create, params: { question_id: question, answer: answer_params }
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

    context "when not authenticated" do
      it "doesn't add new answer for question" do
        expect do
          post :create, params: { question_id: question, answer: answer_params }
        end.not_to change(Answer, :count)
      end

      context do
        before do
          post :create, params: { question_id: question, answer: answer_params }
        end

        it { is_expected.to redirect_to(new_user_session_url) }
        it { is_expected.to set_flash }
      end
    end
  end

  describe "PATCH #update" do
    let(:answer) { create(:answer, question: question, author: user) }
    let(:answer_params) { attributes_for(:answer, question: question, author: user) }

    context "when authenticated" do
      before { sign_in(user) }

      context "when author" do
        context "with valid params" do
          before do
            patch :update, params: { id: answer, answer: answer_params }
          end

          it "updates answer's body with the given param" do
            answer.reload
            expect(answer.body).to eq(answer_params[:body])
          end

          it { is_expected.to redirect_to(question) }
          it { is_expected.to set_flash[:success] }
        end

        context "with invalid params" do
          let(:invalid_params) { attributes_for(:answer, :invalid, question: question, author: user) }

          before do
            patch :update, params: { id: answer, answer: invalid_params }
          end

          it "doesn't update answer attributes" do
            answer.reload
            expect(answer.body).not_to be_nil
          end

          it { is_expected.to render_template("questions/show") }
        end
      end

      context "when not author" do
        let(:other_answer) { create(:answer, question: question) }

        before do
          patch :update, params: { id: other_answer, answer: answer_params }
        end

        it_behaves_like "non-author request"
      end
    end

    context "when not authenticated" do
      before do
        patch :update, params: { id: answer, answer: answer_params }
      end

      it { is_expected.to redirect_to(new_user_session_url) }
      it { is_expected.to set_flash }
    end
  end

  describe "DELETE #destroy" do
    let!(:answer) { create(:answer, question: question, author: user) }

    context "when authenticated" do
      before { sign_in(user) }

      context "when author" do
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

      context "when not author" do
        let!(:other_answer) { create(:answer, question: question) }

        it "doesn't delete the answer" do
          expect do
            delete :destroy, params: { id: other_answer }
          end.not_to change(Answer, :count)
        end

        context do
          before do
            delete :destroy, params: { id: other_answer }
          end

          it_behaves_like "non-author request"
        end
      end
    end

    context "when not authenticated" do
      it "doesn't delete the answer" do
        expect do
          delete :destroy, params: { id: answer }
        end.not_to change(Answer, :count)
      end

      context do
        before do
          delete :destroy, params: { id: answer }
        end

        it { is_expected.to redirect_to(new_user_session_url) }
        it { is_expected.to set_flash }
      end
    end
  end
end
