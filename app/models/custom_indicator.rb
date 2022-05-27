# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_indicators
#
#  id             :bigint           not null, primary key
#  name           :string
#  audio          :string
#  scorecard_uuid :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tag_id         :integer
#  uuid           :string
#
# Todo: refactoring, use only in version 1
class CustomIndicator < ApplicationRecord
  include Tagable

  mount_uploader :audio, AudioUploader

  belongs_to :scorecard, -> { with_deleted }, foreign_key: :scorecard_uuid

  validates :name, presence: true

  before_create :secure_uuid
end
