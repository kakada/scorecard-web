# frozen_string_literal: true

class PublicVotesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_scorecard
  before_action :check_voting_open, except: [:show]

  layout "layouts/footer_less"

  def show
    unless @scorecard.open_voting?
      @voting_closed = true
      return
    end

    @form = PublicVoteForm.new(scorecard: @scorecard)
    @indicators = @scorecard.voting_indicators.includes(:indicator).order(:display_order)
  end

  def create
    unless @scorecard.open_voting?
      render json: { error: I18n.t("public_votes.voting_ended") }, status: :unprocessable_entity
      return
    end

    # Build form object from incoming payload
    form = PublicVoteForm.new(
      scorecard: @scorecard,
      participant_age: params.dig(:participant, :age),
      participant_gender: params.dig(:participant, :gender),
      participant_disability: ActiveModel::Type::Boolean.new.cast(params.dig(:participant, :disability)),
      participant_minority: ActiveModel::Type::Boolean.new.cast(params.dig(:participant, :minority)),
      participant_poor_card: ActiveModel::Type::Boolean.new.cast(params.dig(:participant, :poor_card)),
      participant_youth: ActiveModel::Type::Boolean.new.cast(params.dig(:participant, :youth)),
      ratings: (params[:voting_data] || []).each_with_object({}) { |vote, h| h[vote[:indicator_uuid]] = vote[:score] }
    )

    unless form.valid?
      render json: { errors: form.errors.full_messages }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      # Create participant profile
      @participant = @scorecard.participants.new(participant_params)
      @participant.countable = false # Public votes are not countable in main statistics

      unless @participant.save
        render json: { error: I18n.t("public_votes.participant_creation_failed") }, status: :unprocessable_entity
        return
      end

      # Create ratings from form.ratings (hash indicator_uuid => score)
      (form.ratings || {}).each do |indicator_uuid, score|
        voting_indicator = @scorecard.voting_indicators.find_by(uuid: indicator_uuid)
        next unless voting_indicator

        @scorecard.ratings.create!(
          voting_indicator_uuid: voting_indicator.uuid,
          participant_uuid: @participant.uuid,
          score: score
        )
      end

      render json: { success: true, message: I18n.t("public_votes.vote_submitted") }
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
    def set_scorecard
      @scorecard = Scorecard.find_by!(uuid: params[:scorecard_uuid])
    rescue ActiveRecord::RecordNotFound
      render plain: "Scorecard not found", status: :not_found
    end

    def check_voting_open
      unless @scorecard.open_voting?
        render json: { error: I18n.t("public_votes.voting_closed") }, status: :unprocessable_entity
      end
    end

    def participant_params
      params.require(:participant).permit(:age, :gender, :disability, :minority, :poor_card, :youth)
    end
end
