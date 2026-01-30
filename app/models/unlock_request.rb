# frozen_string_literal: true

# == Schema Information
#
# Table name: unlock_requests
#
#  id              :uuid             not null, primary key
#  scorecard_id    :integer
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
    pending: 0,
    rejected: 1,
    approved: 2
  }

  belongs_to :scorecard
  belongs_to :proposer, class_name: "User"
  belongs_to :reviewer, class_name: "User", optional: true

  validates :reason, presence: true
  validates :reviewer, presence: true, if: -> { approved? || rejected? }
  validates :resolved_date, presence: true, if: -> { approved? || rejected? }
  validates :rejected_reason, presence: true, if: -> { rejected? }

  before_validation :set_resolved_date, if: -> { approved? || rejected? }
  before_create :set_status
  after_save :unlock_scorecard, if: -> { approved? && saved_change_to_status? }

  default_scope { order(created_at: :desc) }
  scope :pendings, -> { where(status: "pending") }

  private
    def unlock_scorecard
      scorecard.unlock_access!
    end

    def set_status
      self.status = :pending
    end

    def set_resolved_date
      self.resolved_date = Time.current
    end
end
