# frozen_string_literal: true

# == Schema Information
#
# Table name: raised_indicators
#
#  id           :bigint           not null, primary key
#  scorecard_id :string
#  indicator_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class RaisedIndicator < ApplicationRecord
  belongs_to :scorecard, foreign_key: :scorecard_uuid
  belongs_to :indicatorable, polymorphic: true
end
