# frozen_string_literal: true

# == Schema Information
#
# Table name: raised_indicators
#
#  id                 :bigint           not null, primary key
#  indicatorable_id   :integer
#  indicatorable_type :string
#  raised_person_id   :integer
#  scorecard_uuid     :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "rails_helper"

RSpec.describe RaisedIndicator, type: :model do
  it { is_expected.to belong_to(:scorecard) }
  it { is_expected.to belong_to(:indicatorable) }
end
