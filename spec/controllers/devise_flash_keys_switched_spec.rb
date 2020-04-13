require "rails_helper"

describe ApplicationController do
  let(:success) { "Success message" }
  let(:danger)  { "Danger message" }

  context "when devise controller" do
    controller(::DeviseController) do
      skip_before_action :authenticate_user!

      def index
        flash[:notice] = "Success message"
        flash[:alert] = "Danger message"
        render inline: ""
      end
    end

    before { request.env["devise.mapping"] = Devise.mappings[:user] }
    before { get :index }

    it "flash[:success] is set to :notice message" do
      expect(controller).to set_flash[:success].to(success)
    end

    it "flash[:alert] is set to :danger message" do
      expect(controller).to set_flash[:danger].to(danger)
    end

    it ":notice key is deleted" do
      expect(controller).not_to set_flash[:notice]
    end

    it ":alert key is deleted" do
      expect(controller).not_to set_flash[:alert]
    end
  end

  context "when is not devise controller" do
    controller do
      skip_before_action :authenticate_user!

      def index
        flash[:notice] = "Success message"
        flash[:alert] = "Danger message"
        render inline: ""
      end
    end

    before { get :index }

    it "flash[:success] isn't set" do
      expect(controller).not_to set_flash[:success]
    end

    it "flash[:danger] isn't set" do
      expect(controller).not_to set_flash[:danger]
    end

    it ":notice key is in place" do
      p controller.flash
      expect(controller).to set_flash[:notice].to(success)
    end

    it ":alert key is in place" do
      expect(controller).to set_flash[:alert].to(danger)
    end
  end
end
