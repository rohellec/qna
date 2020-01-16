require "rails_helper"

describe QuestionsController do
  let(:question) { create(:question) }

  describe "GET index" do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it "assigns array of questions to a variable" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders :index view" do
      expect(response).to render_template(:index)
    end
  end

  describe "GET show" do
    before do
      get :show, params: { id: question }
    end

    it "assigns the requested question to a variable" do
      expect(assigns(:question)).to eq(question)
    end

    it "renders :show view" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET new" do
    before { get :new }

    it "assigns new question to a variable" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "renders :new view" do
      expect(response).to render_template(:new)
    end
  end

  describe "GET edit" do
    before do
      get :edit, params: { id: question }
    end

    it "assigns the requested question to a variable" do
      expect(assigns(:question)).to eq(question)
    end

    it "renders :edit view" do
      expect(response).to render_template(:edit)
    end
  end

  describe "POST create" do
    context "with valid params" do
      let(:valid_params) { attributes_for(:question) }

      it "creates new question" do
        expect do
          post :create, params: { question: valid_params }
        end.to change(Question, :count).by(1)
      end

      it "params equal to created question attributes" do
        post :create, params: { question: valid_params }
        expect(assigns(:question).title).to eq(valid_params[:title])
        expect(assigns(:question).body).to  eq(valid_params[:body])
      end

      it "redirects to created question" do
        post :create, params: { question: valid_params }
        expect(response).to redirect_to(assigns(:question))
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

  describe "PATCH update" do
    before do
      patch :update, params: { id: question, question: question_params }
    end

    context "with valid params" do
      let(:question_params) { attributes_for(:question) }

      it "assigns the requested question to a variable" do
        expect(assigns(:question)).to eq(question)
      end

      it "updates question attributes" do
        question.reload
        expect(question.title).to eq(question_params[:title])
        expect(question.body).to  eq(question_params[:body])
      end

      it "redirects to question" do
        expect(response).to redirect_to(question)
      end
    end

    context "with invalid params" do
      let(:question_params) { attributes_for(:question, :invalid) }

      it "doesn't update question attributes" do
        requested_question = assigns(:question)
        requested_question.reload
        expect(requested_question.title).to eq(question.title)
        expect(requested_question.body).to  eq(question.body)
      end

      it "renders :edit view" do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    let!(:question) { create(:question) }

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
end
