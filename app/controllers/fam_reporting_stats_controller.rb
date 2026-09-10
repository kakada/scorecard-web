# frozen_string_literal: true

class FamReportingStatsController < ApplicationController
  def index
    authorize FamReportingStat
    @fam_reporting_stats = policy_scope(FamReportingStat.order(:source))
  end
end
