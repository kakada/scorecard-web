# frozen_string_literal: true

class PublicVotesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :assign_scorecard
  before_action :check_open_voting, only: [:new, :create]
  before_action :set_locale

  layout "layouts/footer_less"

  def new
    @form = PublicVoteForm.new(scorecard: @scorecard)
  end

  def create
    @form = PublicVoteForm.new(scorecard: @scorecard, params: public_vote_params)

    if PublicVotes::SubmitService.new(@form).call
      redirect_to thank_you_scorecard_vote_path(@scorecard.uuid)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def thank_you
    # Renders a simple thank-you page after successful vote
  end

  private
    def assign_scorecard
      @scorecard = Scorecard.find_by!(uuid: params[:scorecard_uuid])
    end

    def check_open_voting
      if !@scorecard.open_voting?
        render :close_voting, status: :forbidden
      end
    end

    def public_vote_params
      params.require(:public_vote_form)
            .permit(:age, :gender, :disability, :minority, :poor_card, scores: {})
    end

    def set_locale
      I18n.locale = params[:locale] || "km"
    end
end
