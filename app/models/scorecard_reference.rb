# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_references
#
#  id             :bigint           not null, primary key
#  uuid           :string
#  scorecard_uuid :string
#  attachment     :string
#  kind           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class ScorecardReference < ApplicationRecord
  # Uploader
  mount_uploader :attachment, AttachmentUploader

  before_create :secure_uuid

  belongs_to :scorecard, primary_key: "uuid", foreign_key: "scorecard_uuid"

  validates :attachment, presence: true
end
