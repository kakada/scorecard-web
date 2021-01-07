# frozen_string_literal: true

module Scorecards
  class IndicatorsController < ApplicationController
    def index
      @scorecard = Scorecard.find(params[:scorecard_id])
      @criterias = Scorecards::ProposedCriteria.new(@scorecard.uuid).criterias

      respond_to do |format|
        format.js
      end
    end
  end
end
