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
end
