require "rails_helper"

describe QuestionsController do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "GET index" do
    it "renders :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET show" do
    it "renders :show view" do
      get :show, params: { id: question }
      expect(response).to render_template(:show)
    end
  end

  describe "GET new" do
    context "when authenticated" do
      before { sign_in(user) }

      it "renders :new view" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "when not authenticated" do
      before { get :new }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe "GET edit" do
    context "when authenticated" do
      before { sign_in(user) }

      it "renders :edit view" do
        get :edit, params: { id: question }
        expect(response).to render_template(:edit)
      end
    end

    context "when not authenticated" do
      before do
        get :edit, params: { id: question }
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

        it "creates new question" do
          expect do
            post :create, params: { question: params }
          end.to change(Question, :count).by(1)
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

      context "with valid params" do
        before do
          patch :update, params: { id: question, question: params }
        end

        it "updates question attributes" do
          question.reload
          expect(question.title).to eq(params[:title])
          expect(question.body).to  eq(params[:body])
        end

        it "redirects to question" do
          expect(response).to redirect_to(question)
        end
      end

      context "with invalid params" do
        let(:invalid_params) { attributes_for(:question, :invalid) }

        before do
          patch :update, params: { id: question, question: invalid_params }
        end

        it "doesn't update question attributes" do
          question.reload
          expect(question.title).not_to be_nil
        end

        it "renders :edit view" do
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when not authenticated" do
      before do
        patch :update, params: { id: question, question: params }
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe "DELETE destroy" do
    let!(:question) { create(:question) }

    context "when authenticated" do
      before { sign_in(user) }

      it "deletes the question" do
        expect do
          delete :destroy, params: { id: question }
        end.to change(Question, :count).by(-1)
      end

      it "redirects to questions url" do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to(questions_url)
      end
    end

    context "when not authenticated" do
      it "doesn't delete the question" do
        expect do
          delete :destroy, params: { id: question }
        end.not_to change(Question, :count)
      end

      it "redirects to sign in page" do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
