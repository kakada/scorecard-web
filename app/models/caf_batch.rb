# frozen_string_literal: true

# == Schema Information
#
# Table name: caf_batches
#
#  id             :uuid             not null, primary key
#  code           :string
#  total_count    :integer          default(0)
#  valid_count    :integer          default(0)
#  new_count      :integer          default(0)
#  province_count :integer          default(0)
#  user_id        :integer
#  reference      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class CafBatch < ApplicationRecord
  # Uploader
  mount_uploader :reference, AttachmentUploader

  # Association
  belongs_to :user
  has_many :importing_cafs
  has_many :cafs, through: :importing_cafs

  # Callback
  before_create :secure_code

  # Delegation
  delegate :email, to: :user, prefix: :user

  # Nested attributes
  accepts_nested_attributes_for :importing_cafs

  # Instant method
  def edit_count
    valid_count - new_count
  end

  def invalid_count
    total_count - valid_count
  end

  # Class method
  def self.filter(params)
    keyword = params[:keyword].to_s.strip
    scope = all
    scope = scope.where("code LIKE ? OR reference LIKE ?", "%#{keyword}%", "%#{keyword}%") if keyword.present?
    scope
  end
end
