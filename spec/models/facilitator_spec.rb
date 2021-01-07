# frozen_string_literal: true

# == Schema Information
#
# Table name: facilitators
#
#  id             :bigint           not null, primary key
#  caf_id         :integer
#  scorecard_uuid :integer
#  position       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe Facilitator, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
