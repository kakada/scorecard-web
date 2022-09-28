# frozen_string_literal: true

require_relative "scorecards/participant"
require_relative "scorecards/voting_indicator"
require_relative "scorecards/rating"
require_relative "scorecards/raised_indicator"
require_relative "scorecards/scorecard_reference"

module Samples
  class Scorecard
    def self.load(count = 1)
      dependent_models = %w(Participant RaisedIndicator VotingIndicator Rating ScorecardReference)

      count.times do |i|
        scorecard = create_scorecard

        dependent_models.each do |model|
          "::Samples::Scorecards::#{model.camelcase}".constantize.load(scorecard)
        rescue
          Rails.logger.warn "Model #{model} is unknwon"
        end

        scorecard.lock_submit!
      end
    end

    def self.export(type = "json")
      class_name = "Exporters::#{type.camelcase}Exporter"
      class_name.constantize.new(::Scorecard.all).export("scorecards")
    rescue
      Rails.logger.warn "#{class_name} is unknwon"
    end

    private
      def self.create_scorecard
        number_of_caf = rand(1..5)
        number_of_participant = rand(10..15)
        number_of_female = rand(1...number_of_participant)
        conducted_date = Date.today
        facility = ::Facility.where.not(parent_id: nil).sample
        dataset = facility.category.datasets.sample if facility.category.present?
        commune = dataset.present? ? ::Pumi::Commune.find_by_id(dataset.commune_id) : ::Pumi::Commune.all.sample
        local_ngo = ::LocalNgo.all.sample

        ::Scorecard.create({
          conducted_date: conducted_date,
          year: conducted_date.year,
          province_id: commune.province_id,
          district_id: commune.district_id,
          commune_id: commune.id,
          facility_id: facility.id,
          unit_type_id: facility.parent_id,
          dataset_id: dataset.try(:id),
          number_of_caf: number_of_caf,
          number_of_participant: number_of_participant,
          number_of_female: number_of_female,
          local_ngo_id: local_ngo.id,
          program_id: local_ngo.program_id,
          scorecard_type: ::Scorecard::SCORECARD_TYPES.sample.last,
          planned_start_date: conducted_date,
          planned_end_date: conducted_date,
          creator_id: ::User.all.sample.try(:id)
        })
      end
  end
end
