# frozen_string_literal: true

# == Schema Information
#
# Table name: unlock_requests
#
#  id              :uuid             not null, primary key
#  scorecard_uuid  :string
#  proposer_id     :integer
#  reviewer_id     :integer
#  reason          :text
#  rejected_reason :text
#  status          :integer
#  resolved_date   :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class UnlockRequest < ApplicationRecord
  include UnlockRequests::CallbackNotification

  enum status: {
    rejected: 0,
    approved: 1,
    submitted: 2
  }

  belongs_to :scorecard, primary_key: "uuid", foreign_key: "scorecard_uuid"
  belongs_to :proposer, class_name: "User"
  belongs_to :reviewer, class_name: "User", optional: true

  validates :reason, presence: true
  validates :reviewer, presence: true, if: -> { approved? || rejected? }
  validates :resolved_date, presence: true, if: -> { approved? || rejected? }
  validates :rejected_reason, presence: true, if: -> { rejected? }

  before_validation :set_resolved_date, if: -> { approved? || rejected? }
  before_create :set_status
  after_save :unlock_scorecard, if: -> { approved? }

  default_scope { order(created_at: :desc) }
  scope :submitteds, -> { where(status: "submitted") }

  private
    def unlock_scorecard
      scorecard.unlock_access!
    end

    def set_status
      self.status = :submitted
    end

    def set_resolved_date
      self.resolved_date = Time.now
    end
end
