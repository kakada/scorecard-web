# frozen_string_literal: true

class PublicVoteForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # --------------------------------------------------
  # Attributes
  # --------------------------------------------------
  attribute :age, :integer
  attribute :gender, :string
  attribute :disability, :boolean
  attribute :minority, :boolean
  attribute :poor_card, :boolean
  attribute :scores, default: {}

  attr_reader :scorecard

  # --------------------------------------------------
  # Validations
  # --------------------------------------------------
  validates :age, presence: true
  validates :gender, presence: true
  validate :validate_indicator_scores

  # --------------------------------------------------
  # Init
  # --------------------------------------------------
  def initialize(scorecard:, params: {})
    @scorecard = scorecard
    super(params)
  end

  # --------------------------------------------------
  # Data loading
  # --------------------------------------------------
  def indicators
    @indicators ||= scorecard
      .voting_indicators
      .includes(:indicator)
      .order(:display_order)
  end

  # --------------------------------------------------
  # Persistence
  # --------------------------------------------------
  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      participant = create_participant
      create_votes(participant)
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def score_error_for(voting_indicator)
    errors["scores_#{voting_indicator.uuid}"].first
  end

  def score_error?(voting_indicator)
    errors.key?("scores_#{voting_indicator.uuid}")
  end

  private
    def create_participant
      scorecard.participants.create!(
        age: age,
        gender: gender,
        disability: disability,
        minority: minority,
        poor_card: poor_card,
        youth: age&.between?(15, 30)
      )
    end

    def create_votes(participant)
      indicators.each do |voting_indicator|
        Rating.create!(
          scorecard: scorecard,
          participant: participant,
          voting_indicator: voting_indicator,
          score: scores[voting_indicator.uuid.to_s]
        )
      end
    end

    # --------------------------------------------------
    # Custom validations
    # --------------------------------------------------
    def validate_indicator_scores
      indicators.each do |voting_indicator|
        value = scores[voting_indicator.uuid.to_s]

        if value.blank?
          errors.add("scores_#{voting_indicator.uuid}", I18n.t("public_votes.errors.score_required", indicator: voting_indicator.indicator.name))
        end
      end
    end
end
