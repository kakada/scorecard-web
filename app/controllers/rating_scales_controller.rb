# frozen_string_literal: true

class RatingScalesController < ApplicationController
  def index
    authorize RatingScale
  end

  def create
    authorize RatingScale

    if current_program.update(ratings_params)
      redirect_to rating_scales_path
    else
      render :index
    end
  end

  private
    def ratings_params
      params.require(:program).permit(
        rating_scales_attributes: [
          :id, :code, :name, :value,
          language_rating_scales_attributes: [
            :id, :language_id, :language_code, :content, :audio, :remove_audio
          ]
        ]
      )
    end
end
