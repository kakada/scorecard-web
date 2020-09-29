class MediansController < ApplicationController
  def index
    @scorecard = Scorecard.find(params[:scorecard_id])
  end
end
