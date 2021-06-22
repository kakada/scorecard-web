# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_references
#
#  id             :bigint           not null, primary key
#  uuid           :string
#  scorecard_uuid :string
#  attachment     :string
#  kind           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe ScorecardReference, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
