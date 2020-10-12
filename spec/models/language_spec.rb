# frozen_string_literal: true

require "rails_helper"

RSpec.describe Language, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:name) }
end
