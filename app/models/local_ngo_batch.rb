# frozen_string_literal: true

# == Schema Information
#
# Table name: local_ngo_batches
#
#  id          :uuid             not null, primary key
#  code        :string
#  total_count :integer          default(0)
#  valid_count :integer          default(0)
#  reference   :string
#  user_id     :integer
#  program_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class LocalNgoBatch < ApplicationRecord
  attr_writer :importing_local_ngos

  # Uploader
  mount_uploader :reference, AttachmentUploader

  # Association
  belongs_to :program
  belongs_to :user
  has_many :local_ngos

  # Callback
  before_create :secure_code

  # Delegation
  delegate :email, to: :user, prefix: :user

  # Nested attributes
  accepts_nested_attributes_for :local_ngos

  # Instant method
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

  def importing_local_ngos
    @importing_local_ngos ||= []
  end
end
