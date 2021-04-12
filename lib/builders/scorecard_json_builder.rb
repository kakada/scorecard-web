# frozen_string_literal: true

Dir["/app/lib/builders/scorecard_json/*.rb"].each { |file| require file }

class ScorecardJsonBuilder
  attr_accessor :scorecard

  def initialize(scorecard)
    @scorecard = scorecard
  end

  def build
    {
      uuid: scorecard.uuid,
      type: scorecard.scorecard_type,
      unit: scorecard.unit_type.name,
      facility: scorecard.facility_name,
      location: {
        province: scorecard.province_id,
        district: scorecard.district_id,
        commune: scorecard.commune_id,
        school: scorecard.primary_school.try("name_#{I18n.locale}")
      },
      geo_location: build_geo_location,
      planned_start_date: scorecard.planned_start_date,
      planned_end_date: scorecard.planned_end_date,
      conducted_at: scorecard.conducted_date,
      finished_date: scorecard.finished_date,
      language_conducted: scorecard.language_conducted_code,
      lngo: scorecard.local_ngo_name,
      number_of_caf: scorecard.facilitators.length,
      participants: ScorecardJson::ParticipantJsonBuilder.new(scorecard).build,
      proposed_indicators: ScorecardJson::ProposedIndicatorJsonBuilder.new(scorecard).build,
      indicator_developments: ScorecardJson::IndicatorDevelopmentJsonBuilder.new(scorecard).build,
      votings: ScorecardJson::VotingIndicatorJsonBuilder.new(scorecard).build,
      result: ScorecardJson::ResultJsonBuilder.new(scorecard).build,
    }
  end

  private
    def build_geo_location
      return {} unless scorecard.location.present? && scorecard.location.latitude.present? && scorecard.location.longitude.present?

      { lat: scorecard.location.latitude, lon: scorecard.location.longitude }
    end
end
