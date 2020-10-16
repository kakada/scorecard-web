# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to validate_presence_of(:name) }
end
