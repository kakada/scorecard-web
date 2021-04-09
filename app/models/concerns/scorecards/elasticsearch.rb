# frozen_string_literal: true

require 'builders/scorecard_json_builder'

module Scorecards::Elasticsearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    mapping date_detection: false do
      indexes :location_name, type: :text
      indexes :location, type: :geo_point
      indexes :created_at, type: :date
      indexes :updated_at, type: :date
    end

    def self.mappings_hash
      mappings.to_hash
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
