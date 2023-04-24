# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_progresses
#
#  id             :bigint           not null, primary key
#  scorecard_uuid :string
#  status         :integer
#  device_id      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  conducted_at   :datetime
#
class ScorecardProgress < ApplicationRecord
  # Module
  include ScorecardProgresses::ScorecardCallbackConcern

  # Association
  belongs_to :scorecard, primary_key: "uuid", foreign_key: "scorecard_uuid"
  belongs_to :user

  # Enum
  enum status: {
    downloaded: 1,
    renewed: 4,
    running: 2,
    in_review: 3,
    completed: 5
  }

  DOWNLOADED = "downloaded"

  # Callback
  before_create :set_conducted_at

  # Scope
  scope :downloadeds, -> { where(status: :downloaded) }

  private
    def set_conducted_at
      self.conducted_at ||= created_at
    end
end
