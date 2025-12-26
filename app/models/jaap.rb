# frozen_string_literal: true

# == Schema Information
#
# Table name: jaaps
#
#  id                :bigint           not null, primary key
#  title             :string
#  description       :text
#  uuid              :string           not null
#  program_id        :bigint
#  scorecard_id      :string
#  user_id           :bigint
#  field_definitions :jsonb            default([])
#  rows_data         :jsonb            default([])
#  completed_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Jaap < ApplicationRecord
  before_validation :generate_uuid, on: :create

  belongs_to :program
  belongs_to :scorecard, foreign_key: :scorecard_id, primary_key: :uuid, optional: true
  belongs_to :user

  validates :title, presence: true
  validates :uuid, presence: true, uniqueness: true
  validates :field_definitions, presence: true

  # Default field definitions for JAAP form
  DEFAULT_FIELD_DEFINITIONS = [
    { key: 'issue', label: 'Issue/Problem', type: 'text', required: true },
    { key: 'root_cause', label: 'Root Cause', type: 'textarea', required: true },
    { key: 'action', label: 'Action', type: 'text', required: true },
    { key: 'responsible_person', label: 'Responsible Person', type: 'text', required: true },
    { key: 'deadline', label: 'Deadline', type: 'date', required: true },
    { key: 'budget', label: 'Budget', type: 'number', required: false },
    { key: 'status', label: 'Status', type: 'select', options: ['Not Started', 'In Progress', 'Completed', 'Delayed'], required: true }
  ].freeze

  def self.default_field_definitions
    DEFAULT_FIELD_DEFINITIONS
  end

  def completed?
    completed_at.present?
  end

  def complete!
    update(completed_at: Time.current)
  end

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
