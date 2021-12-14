# frozen_string_literal: true

# == Schema Information
#
# Table name: voting_indicators
#
#  indicatorable_id   :integer
#  indicatorable_type :string
#  scorecard_uuid     :string
#  median             :integer
#  strength           :text
#  weakness           :text
#  suggested_action   :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  uuid               :string           default("uuid_generate_v4()"), not null, primary key
#  display_order      :integer
#
class VotingIndicator < ApplicationRecord
  belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true
  belongs_to :indicatorable, polymorphic: true
  has_many :ratings, foreign_key: :voting_indicator_uuid, dependent: :destroy
  has_many :suggested_actions, foreign_key: :voting_indicator_uuid, dependent: :destroy
  has_many :raised_indicators, foreign_key: :voting_indicator_uuid

  accepts_nested_attributes_for :suggested_actions, allow_destroy: true

  enum median: {
    very_bad: 1,
    bad: 2,
    acceptable: 3,
    good: 4,
    very_good: 5
  }

  serialize :strength, Array
  serialize :weakness, Array
  serialize :suggested_action, Array

  before_create :secure_uuid
end
