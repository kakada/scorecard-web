# frozen_string_literal: true

# == Schema Information
#
# Table name: program_scorecard_types
#
#  id         :uuid             not null, primary key
#  code       :integer
#  name_en    :string
#  name_km    :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe ProgramScorecardType, type: :model do
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:name_km) }
  it { is_expected.to validate_presence_of(:name_en) }
end
