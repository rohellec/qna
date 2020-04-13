require "rails_helper"

shared_examples "non-author request" do
  context do
    it { is_expected.to set_flash[:danger] }
    it { is_expected.to redirect_to(root_url) }
  end
end

describe QuestionsController do
  let(:user) { create(:user) }
  let(:user_question)  { create(:question, author: user) }
  let(:other_question) { create(:question) }

  describe "GET index" do
    before { get :index }

    it { is_expected.to render_template(:index) }
  end

  describe "GET show" do
    before do
      get :show, params: { id: user_question }
    end

    it { is_expected.to render_template(:show) }
  end

  describe "GET new" do
    context "when authenticated" do
      before { sign_in(user) }
      before { get :new }

      it { is_expected.to render_template(:new) }
    end

    context "when not authenticated" do
      before { get :new }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe "GET edit" do
    context "when authenticated" do
      before { sign_in(user) }

      context "when author" do
        before do
          get :edit, params: { id: user_question }
        end

        it { is_expected.to render_template(:edit) }
      end

      context "when not author" do
        before do
          get :edit, params: { id: other_question }
        end

        it_behaves_like "non-author request"
      end
    end

    context "when not authenticated" do
      before do
        get :edit, params: { id: user_question }
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe "POST create" do
    let(:params) { attributes_for(:question) }

    context "when authenticated" do
      before { sign_in(user) }

      context "with valid params" do
        let(:question) { Question.last }

        it "creates new question for user" do
          expect do
            post :create, params: { question: params }
          end.to change(user.questions, :count).by(1)
        end

        it "params equal to created question attributes" do
          post :create, params: { question: params }
          expect(question.title).to eq(params[:title])
          expect(question.body).to  eq(params[:body])
        end

        it "redirects to created question" do
          post :create, params: { question: params }
          expect(response).to redirect_to(question)
        end
      end

      context "with invalid params" do
        let(:invalid_params) { attributes_for(:question, :invalid) }

        it "doesn't create new question" do
          expect do
            post :create, params: { question: invalid_params }
          end.not_to change(Question, :count)
        end

        it "renders :new view" do
          post :create, params: { question: invalid_params }
          expect(response).to render_template(:new)
        end
      end
    end

    context "when not authenticated" do
      it "doesn't create new question" do
        expect do
          post :create, params: { question: params }
        end.not_to change(Question, :count)
      end

      it "redirects to sign in page" do
        post :create, params: { question: params }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH update" do
    let(:params) { attributes_for(:question) }

    context "when authenticated" do
      before { sign_in(user) }

      context "when author" do

        context "with valid params" do
          before do
            patch :update, params: { id: user_question, question: params }
          end

          it "updates question attributes" do
            user_question.reload
            expect(user_question.title).to eq(params[:title])
            expect(user_question.body).to  eq(params[:body])
          end

          it "redirects to question" do
            expect(response).to redirect_to(user_question)
          end
        end

        context "with invalid params" do
          let(:invalid_params) { attributes_for(:question, :invalid) }

          before do
            patch :update, params: { id: user_question, question: invalid_params }
          end

          it "doesn't update question attributes" do
            user_question.reload
            expect(user_question.title).not_to be_nil
          end

          it "renders :edit view" do
            expect(response).to render_template(:edit)
          end
        end
      end

      context "when not author" do
        before do
          patch :update, params: { id: other_question, question: params }
        end

        it "doesn't update question attributes" do
          other_question.reload
          expect(user_question.title).not_to eq(params[:title])
          expect(user_question.body).not_to  eq(params[:body])
        end

        it_behaves_like "non-author request"
      end
    end

    context "when not authenticated" do
      before do
        patch :update, params: { id: user_question, question: params }
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe "DELETE destroy" do
    let!(:user_question)  { create(:question, author: user) }
    let!(:other_question) { create(:question) }

    context "when authenticated" do
      before { sign_in(user) }

      context "when author" do
        it "deletes the question" do
          expect do
            delete :destroy, params: { id: user_question }
          end.to change(Question, :count).by(-1)
        end

        it "redirects to questions url" do
          delete :destroy, params: { id: user_question }
          expect(response).to redirect_to(questions_url)
        end
      end

      context "when not author" do
        it "doesn't delete the question" do
          expect do
            delete :destroy, params: { id: other_question }
          end.not_to change(Question, :count)
        end

        context do
          before do
            delete :destroy, params: { id: other_question }
          end

          it_behaves_like "non-author request"
        end
      end
    end

    context "when not authenticated" do
      it "doesn't delete the question" do
        expect do
          delete :destroy, params: { id: user_question }
        end.not_to change(Question, :count)
      end

      it "redirects to sign in page" do
        delete :destroy, params: { id: user_question }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
