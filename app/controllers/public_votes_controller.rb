# frozen_string_literal: true

class PublicVotesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_scorecard
  before_action :check_voting_open, except: [:show]

  layout "layouts/minimal"

  def show
    unless @scorecard.voting_open?
      @voting_closed = true
      return
    end

    @participant = Participant.new
    @indicators = @scorecard.voting_indicators.includes(:indicator).order(:display_order)
  end

  def create
    unless @scorecard.voting_open?
      render json: { error: I18n.t("public_votes.voting_ended") }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      # Create participant profile
      @participant = @scorecard.participants.new(participant_params)
      @participant.countable = false # Public votes are not countable in main statistics
      
      unless @participant.save
        render json: { errors: @participant.errors.full_messages }, status: :unprocessable_entity
        return
      end

      # Create ratings from voting data
      voting_data = params[:voting_data] || []
      voting_data.each do |vote|
        # The indicator_uuid here is actually the voting_indicator uuid
        voting_indicator = @scorecard.voting_indicators.find_by(uuid: vote[:indicator_uuid])
        next unless voting_indicator

        # Create rating
        @scorecard.ratings.create!(
          voting_indicator_uuid: voting_indicator.uuid,
          participant_uuid: @participant.uuid,
          score: vote[:score]
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
      unless @scorecard.voting_open?
        render json: { error: I18n.t("public_votes.voting_closed") }, status: :unprocessable_entity
      end
    end

    def participant_params
      params.require(:participant).permit(:age, :gender, :disability, :minority, :poor_card, :youth)
    end
end
