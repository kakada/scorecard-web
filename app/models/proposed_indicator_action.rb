# frozen_string_literal: true

# == Schema Information
#
# Table name: proposed_indicator_actions
#
#  id                    :uuid             not null, primary key
#  voting_indicator_uuid :string
#  indicator_action_id   :uuid
#  scorecard_uuid        :string
#  selected              :boolean          default(FALSE)
#  kind                  :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class ProposedIndicatorAction < ApplicationRecord
  enum kind: IndicatorAction.kinds

  belongs_to :voting_indicator, foreign_key: :voting_indicator_uuid, optional: true
  belongs_to :indicator_action, optional: true
  belongs_to :scorecard, foreign_key: :scorecard_uuid, primary_key: :uuid, optional: true

  scope :selecteds, -> { where(selected: true) }
  accepts_nested_attributes_for :indicator_action, allow_destroy: true

  after_validation :set_kind

  private
    def set_kind
      self.kind = indicator_action.kind
    end
end
