# frozen_string_literal: true

# == Schema Information
#
# Table name: swots
#
#  id                  :bigint           not null, primary key
#  scorecard_uuid      :string
#  voting_issue_id     :integer
#  display_order       :integer
#  strength            :text
#  weakness            :text
#  improvement         :text
#  activity            :text
#  rating_median_score :float
#  rating_result       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require "rails_helper"

RSpec.describe Swot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end