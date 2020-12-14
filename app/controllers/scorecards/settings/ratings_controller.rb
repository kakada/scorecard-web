# frozen_string_literal: true

module Scorecards
  module Settings
    class RatingsController < ApplicationController
      def index
      end

      def create
        if current_program.update(ratings_params)
          redirect_to scorecards_settings_ratings_path
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
                :id, :language_id, :language_code, :audio, :remove_audio
              ]
            ]
          )
        end
    end
  end
end
