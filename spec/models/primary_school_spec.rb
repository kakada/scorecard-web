# frozen_string_literal: true

require "rails_helper"

RSpec.describe PrimarySchool, type: :model do
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:name_km) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:commune_id) }
end
