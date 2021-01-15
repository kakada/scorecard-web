# frozen_string_literal: true

class ScorecardJsonBuilder
  attr_accessor :scorecard

  def initialize(scorecard)
    @scorecard = scorecard
  end

  def build
    _scorecard = scorecard.as_json
    _scorecard["location"] = scorecard.location.try(:as_json)
    _scorecard["proposed_criterias"] = ::Scorecards::ProposedCriteria.new(scorecard).criterias
    _scorecard["voting_criterias"] = ::Scorecards::VotingCriteria.new(scorecard).criterias
    _scorecard
  end
end
