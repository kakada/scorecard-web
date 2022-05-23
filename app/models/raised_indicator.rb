# frozen_string_literal: true

# == Schema Information
#
# Table name: raised_indicators
#
#  id                    :bigint           not null, primary key
#  indicatorable_id      :integer
#  indicatorable_type    :string
#  scorecard_uuid        :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  tag_id                :integer
#  participant_uuid      :string
#  selected              :boolean          default(FALSE)
#  voting_indicator_uuid :string
#  indicator_uuid        :string
#
# Todo: consider change name to ProposedIndicator
class RaisedIndicator < ApplicationRecord
  include Tagable

  belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true
  belongs_to :indicatorable, polymorphic: true, optional: true
  belongs_to :indicator, foreign_key: :indicator_uuid, primary_key: :uuid, optional: true
  belongs_to :tag, optional: true
  belongs_to :voting_indicator, foreign_key: :voting_indicator_uuid, optional: true

  scope :selecteds, -> { where(selected: true) }

  after_validation :set_indicator_uuid

  private
    def set_indicator_uuid
      self.indicator_uuid ||= indicatorable.try(:uuid)
    end
end
