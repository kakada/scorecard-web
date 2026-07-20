# frozen_string_literal: true

class VotingSubmissionSerializer < ActiveModel::Serializer
  attributes :uuid, :age, :gender, :disability, :minority, :poor_card, :youth, :submitted_at, :device_submission_token

  def submitted_at
    object.created_at
  end

  has_many :ratings, serializer: RatingSerializer
end
