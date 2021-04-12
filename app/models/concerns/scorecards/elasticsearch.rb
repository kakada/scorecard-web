# frozen_string_literal: true

require "builders/scorecard_json_builder"

module Scorecards::Elasticsearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    mapping do
      indexes :uuid, type: :text
      indexes :type, type: :text
      indexes :unit_type, type: :text
      indexes :facility, type: :text
      indexes :location, type: :object
      indexes :geo_location, type: :geo_point
      indexes :planned_start_date, type: :date
      indexes :planned_end_date, type: :date
      indexes :conducted_at, type: :date
      indexes :finished_date, type: :date
      indexes :language_conducted, type: :text
      indexes :lngo, type: :text
      indexes :number_of_caf, type: :integer
      indexes :participants, type: :object
      indexes :proposed_indicators, type: :object
      indexes :indicator_developments, type: :object
      indexes :votings, type: :object
      indexes :result, type: :object
    end

    def index_document_async
      ::IndexWorker.perform_async(:index, uuid, program_id)
    end

    def delete_document_async
      ::IndexWorker.perform_async(:delete, uuid, program_id)
    end

    def index_document
      client.index index: program.index_name, id: uuid, body: as_indexed_json
    end

    def as_indexed_json
      ::ScorecardJsonBuilder.new(self).build
    end

    def client
      @client ||= ::Elasticsearch::Model.client
    end
  end
end
