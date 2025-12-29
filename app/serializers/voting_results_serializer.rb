# frozen_string_literal: true

class VotingResultsSerializer < ActiveModel::Serializer
  attributes :uuid, :indicator_uuid, :indicatorable_id, :indicatorable_type, :median, :display_order

  def median
    object.median_before_type_cast
  end
end
