# frozen_string_literal: true

class StaticPageStatsController < ApplicationController
  def index
    authorize Ahoy::Event, :index?

    @event_names = StaticPage.order(:slug).map(&:event_name)
    @pagy, @events = pagy(policy_scope(Ahoy::Event.filter(filter_params)).includes(:visit).order(time: :desc))
  end

  private
    def filter_params
      params.permit(:start_time, :end_time, name: [])
    end
end
