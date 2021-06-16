# frozen_string_literal: true

module Scorecards
  class IndicatorsController < ApplicationController
    def index
      @scorecard = Scorecard.find_by(uuid: params[:scorecard_id])
      @criterias = Scorecards::ProposedCriteria.new(@scorecard).criterias

      respond_to do |format|
        format.js
      end
    end
  end
end
