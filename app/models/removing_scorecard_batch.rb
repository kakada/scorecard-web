# frozen_string_literal: true

# == Schema Information
#
# Table name: removing_scorecard_batches
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
class RemovingScorecardBatch < ApplicationRecord
  attr_writer :removing_scorecards
  attr_writer :removing_scorecard_codes
  attr_accessor :confirm_removing_scorecard_codes

  # Association
  belongs_to :user
  belongs_to :program
  has_many :scorecards, -> { only_deleted }

  # Validation
  validate :secure_confirmation

  # Callback
  before_create :secure_code
  after_create :soft_delete_scorecards

  # Uploader
  mount_uploader :reference, AttachmentUploader

  # Delegation
  delegate :email, to: :user, prefix: :user

  # Instant methods
  def removing_scorecard_codes
    @removing_scorecard_codes || []
  end

  def removing_scorecards
    @removing_scorecards || []
  end

  def self.filter(params)
    keyword = params[:keyword].to_s.strip
    scope = all
    scope = scope.where("code LIKE ?", "%#{keyword}%") if keyword.present?
    scope = scope.where(program_id: params[:program_id]) if params[:program_id].present?
    scope
  end

  private
    def soft_delete_scorecards
      to_remove_scorecards = program.scorecards.where(uuid: removing_scorecard_codes)
      to_remove_scorecards.update_all(removing_scorecard_batch_id: id)
      to_remove_scorecards.destroy_all
    end

    def secure_confirmation
      return if removing_scorecard_codes.present? && removing_scorecard_codes.values_at(0, -1).join == confirm_removing_scorecard_codes

      errors.add :scorecards, :mismatch, message: "mismatch removing scorecard codes"

      throw(:abort)
    end
end
