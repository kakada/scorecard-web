# frozen_string_literal: true

module Scorecards::FacilityMigrationConcern
  extend ActiveSupport::Concern

  included do
    validate :validate_progress_status, on: :facility_migration
    validate :validate_raised_custom_indicator, on: :facility_migration
    validate :validate_facility, on: :facility_migration

    def migrate_facility_to(new_facility_id, dataset_code = nil)
      self.facility_id = new_facility_id
      self.unit_type_id = facility.try(:parent_id)
      self.dataset_id = Dataset.find_by(code: dataset_code).try(:id)

      if save(context: :facility_migration)
        @indicators.update_all(categorizable_id: facility_id)
      end
    end

    private
      def validate_progress_status
        errors.add(:progress, :invalid, message: "must be in review status") unless in_review?
      end

      def validate_raised_custom_indicator
        @indicators = Indicator.where(uuid: raised_indicators.map(&:indicator_uuid).uniq)

        errors.add(:raised_indicators, :invalid, message: "must be all custom indicators") if @indicators.present? && !@indicators.all?(&:custom?)
      end

      def validate_facility
        errors.add(:facility, :invalid, message: "doesn't belong to the same program") if program.facilities.only_children.find_by(id: facility_id).nil?
      end
  end
end
