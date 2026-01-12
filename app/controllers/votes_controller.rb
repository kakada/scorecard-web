# frozen_string_literal: true

class VotesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :assign_scorecard
  before_action :check_open_voting, only: [:new, :create]
  before_action :set_locale

  layout "layouts/footer_less"

  def index
    redirect_to new_scorecard_vote_path(@scorecard.token)
  end

  def new
    @form = PublicVoteForm.new(scorecard: @scorecard)
    set_open_graph_tags
  end

  def create
    @form = PublicVoteForm.new(scorecard: @scorecard, params: public_vote_params)

    if PublicVotes::SubmitService.new(@form).call
      redirect_to scorecard_vote_path(@scorecard.token, "thank-you")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # Renders a simple thank-you page after successful vote
  end

  private
    def assign_scorecard
      @scorecard = Scorecard.find_by!(token: params[:scorecard_token])
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

    def set_open_graph_tags
      og_title = I18n.t("meta_tags.voting.title", scorecard: "#{@scorecard.uuid}(#{@scorecard.location_short_detail})", default: "Community Scorecard Voting")
      og_description = I18n.t("meta_tags.voting.description", default: "Participate in the community scorecard voting")
      og_url = request.original_url
      og_image = qr_code_image_url

      set_meta_tags(
        og: {
          title: og_title,
          description: og_description,
          url: og_url,
          image: og_image,
          type: "website"
        },
        twitter: {
          card: "summary_large_image",
          title: og_title,
          description: og_description,
          image: og_image
        }
      )
    end

    def qr_code_image_url
      @scorecard.qr_code_url&.then do |url|
        url.start_with?("http") ? url : request.base_url + url
      end
    end
end
