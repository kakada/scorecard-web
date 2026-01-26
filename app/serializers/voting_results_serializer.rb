# frozen_string_literal: true

class VotingResultsSerializer < ActiveModel::Serializer
  attributes :uuid, :indicator_uuid, :median, :display_order, :results

  SCORE_RANGE = VotingIndicator.medians.values.freeze

  def median
    object.median_before_type_cast
  end

  def results
    counts = instance_options[:rating_counts]

    SCORE_RANGE.map do |score|
      {
        score: score,
        vote_count: counts.fetch([object.uuid, score], 0)
      }
    end
  end
end
