require 'rails_helper'

describe Question do
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
end
