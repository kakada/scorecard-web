# frozen_string_literal: true

require "builders/excel_builders/voting_indicator_raw_data_excel_builder"

class VotingIndicatorsController < ApplicationController
  def index
    respond_to do |format|
      format.xlsx do
        limit     = ExcelBuilders::VotingIndicatorRawDataExcelBuilder::SCORECARD_LIMIT
        relation  = fetch_scorecards

        if relation.limit(limit + 1).count > limit
          flash[:alert] = t("voting_indicator.batch_limit_exceeded", max_record: limit)
          redirect_to root_path and return
        end

        @scorecards = relation.includes(voting_indicators: [:indicator, :ratings])

        render xlsx: "index",
               filename: "voting_indicators_#{Time.current.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
      end
    end
  end

  private
    def fetch_scorecards
      policy_scope(Scorecard.filter(filter_params).order(sort_param))
    end

    def filter_params
      params.permit(
        :start_date, :end_date, :uuid, :filter, :scorecard_type, :batch_code,
        years: [], province_ids: [], local_ngo_ids: [], facility_ids: []
      ).merge(program_id: current_user.program_id)
    end
end
