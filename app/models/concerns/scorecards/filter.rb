# frozen_string_literal: true

module Scorecards::Filter
  extend ActiveSupport::Concern

  included do
    PLANNED_STATUSES = %w[planned renewed downloaded].freeze
    RUNNING_STATUSES = %w[running open_voting close_voting].freeze

    class << self
      def filter(params = {})
        scope = all
        scope = filter_by_uuid(scope, params[:uuid])
        scope = filter_by_date_range(scope, params[:start_date], params[:end_date])
        scope = filter_by_progress(scope, params[:filter])
        scope = apply_filter(scope, :facility_id, params[:facility_ids])
        scope = apply_filter(scope, :local_ngo_id, params[:local_ngo_ids])
        scope = apply_filter(scope, :province_id, params[:province_ids])
        scope = apply_filter(scope, :year, params[:years])
        scope = apply_filter(scope, :scorecard_type, params[:scorecard_type])
        scope = apply_filter(scope, :scorecard_batch_code, params[:batch_code])
        scope
      end

      def filter_by_uuid(scope, uuid)
        return scope unless uuid.present?

        scope.where("uuid ILIKE ?", "%#{uuid}%")
      end

      def filter_by_progress(scope, status)
        return scope unless status.present?

        case status
        when "planned"
          scope.where(progress: PLANNED_STATUSES)
        when "running"
          scope.where(progress: RUNNING_STATUSES)
        else
          scope.where(progress: status)
        end
      end

      def filter_by_date_range(scope, start_date, end_date)
        return scope unless start_date.present? && end_date.present?

        scope.where(planned_start_date: start_date..end_date)
      end

      def apply_filter(scope, column, value)
        value.present? ? scope.where(column => value) : scope
      end
    end
  end
end
