# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe ScorecardType, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to validate_presence_of(:name) }
end
