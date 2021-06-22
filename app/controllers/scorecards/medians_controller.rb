# frozen_string_literal: true

module Scorecards
  class MediansController < ApplicationController
    def index
      @scorecard = Scorecard.find_by(uuid: params[:scorecard_id])
      @voting_indicators = Scorecards::VotingCriteria.new(@scorecard).criterias

      respond_to do |format|
        format.js
      end
    end
  end
end
