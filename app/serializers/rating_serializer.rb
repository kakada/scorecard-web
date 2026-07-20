# frozen_string_literal: true

class RatingSerializer < ActiveModel::Serializer
  attributes :uuid, :voting_indicator_uuid, :score
end
