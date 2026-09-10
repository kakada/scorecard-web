# frozen_string_literal: true

class FamReportingStatsController < ApplicationController
  def index
    authorize Ahoy::Event, :index?

    @pagy, @events = pagy(policy_scope(Ahoy::Event.where(name: "view_fam_reporting").includes(:visit).order(time: :desc)))
  end
end
