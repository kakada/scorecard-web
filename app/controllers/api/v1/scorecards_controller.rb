# frozen_string_literal: true

module Api
  module V1
    class ScorecardsController < ApiController
      before_action :assign_scorecard

      def show
        respond_to do |format|
          format.json do
            authorize @scorecard, :download?

            render json: @scorecard
          end

          format.pdf do
            authorize @scorecard, :download_pdf?

            pdf_html = ActionController::Base.new.render_to_string(inline: PdfTemplateInterpreter.new(@scorecard.uuid).interpreted_message, layout: "pdf")
            pdf = WickedPdf.new.pdf_from_string(pdf_html)

            send_data pdf, filename: "scorecard_#{@scorecard.uuid}.pdf"
          end
        end
      end

      def update
        authorize @scorecard, :submit?

        if @scorecard.update(scorecard_params)
          @scorecard.lock_submit!
          render json: @scorecard, status: :ok
        else
          render json: { errors: @scorecard.errors }, status: :unprocessable_entity
        end
      end

      private
        def assign_scorecard
          @scorecard = Scorecard.find_by(uuid: params[:id])

          raise ActiveRecord::RecordNotFound, with: :render_record_not_found if @scorecard.nil?
        end

        def scorecard_params
          param = params.require(:scorecard).permit(
            :conducted_date, :number_of_caf, :number_of_participant, :number_of_female,
            :number_of_disability, :number_of_ethnic_minority, :number_of_youth, :number_of_id_poor,
            :finished_date, :language_conducted_code, :running_date, :device_type, :device_token,
            :proposed_indicator_method,
            facilitators_attributes: [ :id, :caf_id, :position, :scorecard_uuid ],
            participants_attributes: [ :uuid, :age, :gender, :disability, :minority, :youth, :poor_card, :scorecard_uuid ],
            raised_indicators_attributes: [
              :indicator_uuid, :indicatorable_id, :indicatorable_type, :participant_uuid, :selected, :voting_indicator_uuid, :scorecard_uuid, tag_attributes: [:name]
            ],
            voting_indicators_attributes: [
              :uuid, :indicator_uuid, :indicatorable_id, :indicatorable_type, :participant_uuid,
              :median, :scorecard_uuid, :display_order,
              # Todo remove after device is no longer installed mobile app 1.4.2 (require report from play store)
              strength: [], weakness: [], suggested_action: [],
              suggested_actions_attributes: [ :voting_indicator_uuid, :scorecard_uuid, :content, :selected ],

              indicator_activities_attributes: [ :uuid, :voting_indicator_uuid, :scorecard_uuid, :content, :selected, :type ],

              proposed_indicator_actions_attributes: [ :voting_indicator_uuid, :indicator_action_id, :selected, :scorecard_uuid,
                indicator_action_attributes: [:name, :kind, :predefined, :indicator_uuid]
              ]
            ],
            ratings_attributes: [ :uuid, :voting_indicator_uuid, :participant_uuid, :scorecard_uuid, :score ]
          )

          # Todo remove after device is no longer installed mobile app 1.4.2 (require report from play store)
          (param[:raised_indicators_attributes] || []).each do |ri|
            ri[:indicatorable_type] = "Indicators::CustomIndicator" if ri[:indicatorable_type] == "CustomIndicator"
          end
          (param[:voting_indicators_attributes] || []).each do |ri|
            ri[:indicatorable_type] = "Indicators::CustomIndicator" if ri[:indicatorable_type] == "CustomIndicator"
          end

          param
        end
    end
  end
end
