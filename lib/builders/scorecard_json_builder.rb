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
    _scorecard["participants"] = build_participant(scorecard)
    _scorecard
  end

  private
    def build_participant(scorecard)
      participants = [ { type: "female", count: scorecard.participants.select { |participant| participant.gender == "female" }.length } ]

      %w(disability minority poor_card youth).each do |type|
        participants << { type: type, count: scorecard.participants.select { |participant| !!participant.send(type) }.length }
      end

      participants
    end
end
