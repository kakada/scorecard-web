# frozen_string_literal: true

class ProgramClone < ApplicationRecord
  CLONE_METHODS = %w[sample program].freeze
  STATUSES = %w[pending processing completed failed].freeze
  COMPONENTS = %w[languages facilities indicators rating_scales pdf_templates].freeze

  enum status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }

  belongs_to :source_program, class_name: "Program", optional: true
  belongs_to :target_program, class_name: "Program"
  belongs_to :user

  validates :clone_method, presence: true, inclusion: { in: CLONE_METHODS }
  validates :selected_components, presence: true
  validate :validate_source_program_for_program_clone_method
  validate :validate_selected_components

  def clone_from_sample?
    clone_method == "sample"
  end

  def clone_from_program?
    clone_method == "program"
  end

  private
    def validate_source_program_for_program_clone_method
      if clone_method == "program" && source_program_id.blank?
        errors.add(:source_program_id, "must be present when clone method is 'program'")
      end
    end

    def validate_selected_components
      return if selected_components.blank?

      invalid_components = selected_components - COMPONENTS
      if invalid_components.any?
        errors.add(:selected_components, "contains invalid components: #{invalid_components.join(', ')}")
      end
    end
end
