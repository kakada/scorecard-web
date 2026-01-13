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
    planned: 0,
    downloaded: 1,
    running: 2,
    renewed: 3,

    # Additional statuses for online mode (open voting and close voting):
    # - When the user submits the first step of an online scorecard,
    #   create a scorecard progress record with status `open_voting`, and scorecard will generate qr_code for voting url.
    # - After voting is closed, create a scorecard progress status to `close_voting`.
    open_voting: 4,
    close_voting: 5,

    in_review: 6,
    completed: 7
  }

  delegate :email, to: :user, prefix: :user, allow_nil: true

  DOWNLOADED = "downloaded"

  # Callback
  before_create :set_conducted_at

  private
    def set_conducted_at
      self.conducted_at ||= created_at
    end
end
