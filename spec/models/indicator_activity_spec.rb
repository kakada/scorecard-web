# frozen_string_literal: true

# == Schema Information
#
# Table name: indicator_activities
#
#  id                    :uuid             not null, primary key
#  voting_indicator_uuid :string
#  scorecard_uuid        :string
#  content               :text
#  selected              :boolean
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require "rails_helper"

RSpec.describe IndicatorActivity, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
