# frozen_string_literal: true

module Scorecards
  class IndicatorsController < ApplicationController
    def index
      @scorecard = Scorecard.find(params[:scorecard_id])
      @tags = Scorecards::ProposedCriteria.new(@scorecard.uuid).tags
    end
  end
end
