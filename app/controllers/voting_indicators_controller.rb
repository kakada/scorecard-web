# frozen_string_literal: true

class VotingIndicatorsController < ApplicationController
  def index
    respond_to do |format|
      format.xlsx {
        @scorecards = fetch_scorecards
        
        if @scorecards.length > 50
          flash[:alert] = t("voting_indicator.batch_limit_exceeded", max_record: 50)
          redirect_to root_path
        else
          render xlsx: "index", filename: "voting_indicators_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
        end
      }
    end
  end

  private
    def fetch_scorecards
      scorecards = policy_scope(Scorecard)
      
      # Filter by scorecard UUID if provided
      if params[:scorecard_uuid].present?
        scorecards = scorecards.where(uuid: params[:scorecard_uuid])
      end
      
      # Filter by scorecard batch code if provided
      if params[:batch_code].present?
        scorecards = scorecards.where(scorecard_batch_code: params[:batch_code])
      end
      
      # Filter by program (from current user)
      scorecards = scorecards.where(program_id: current_user.program_id) if current_user.program_id.present?
      
      scorecards.includes(:voting_indicators, :ratings, voting_indicators: [:indicator, :ratings])
    end
    
    def policy_scope(scope)
      Pundit.policy_scope!(current_user, scope)
    end
end
