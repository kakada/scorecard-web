# frozen_string_literal: true

module Scorecards::Filter
  extend ActiveSupport::Concern

  included do
    def self.filter(params = {})
      scope = all
      scope = scope.where(uuid: params[:uuid]) if params[:uuid].present?
      scope = scope.where("conducted_date >= ?", params[:start_date]) if params[:start_date].present?
      scope = scope.where(facility_id: params[:facility_id]) if params[:facility_id].present?
      scope = scope.where(local_ngo_id: params[:local_ngo_id]) if params[:local_ngo_id].present?
      scope = scope.where(province_id: params[:province_id]) if params[:province_id].present?
      scope = scope.where(year: params[:year]) if params[:year].present?
      scope = scope.where(locked_at: nil) if params[:filter] == "planned"
      scope = scope.where.not(locked_at: nil) if params[:filter] == "locked"
      scope
    end
  end
end
