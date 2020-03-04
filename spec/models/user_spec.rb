require "rails_helper"

describe User do
  it { is_expected.to have_many(:questions) }

  let(:user) { create(:user) }

  describe "#author?(resource)" do
    context "when resource author is the same as user" do
      let(:resource) { create(:question, author: user) }

      it { expect(user.author?(resource)).to be_truthy }
    end

    context "when resource author is other user" do
      let(:other_user) { create(:user) }
      let(:resource) { create(:question, author: other_user) }

      it { expect(user.author?(resource)).to be_falsey }
    end
  end
end
