# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards_cafs
#
#  id           :bigint           not null, primary key
#  caf_id       :integer
#  scorecard_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ScorecardsCaf < ApplicationRecord
  belongs_to :scorecard
  belongs_to :caf
end
