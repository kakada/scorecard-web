# frozen_string_literal: true

class IndexWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'index_document'

  def perform(operation, scorecard_uuid, program_id)
    case operation.to_s
    when /index/
      scorecard = Scorecard.find_by(uuid: scorecard_uuid)
      scorecard.index_document if scorecard.present?
    when /delete/
      delete_document(scorecard_uuid, program_id)
    else
      raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end

  private
    def delete_document(scorecard_uuid, program_id)
      program = Program.find_by(id: program_id)
      client.delete(index: program.index_name, id: scorecard_uuid) if program.present?
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      logger.debug "Scorecard not found, ID: #{scorecard_uuid}"
    end

    def client
      @client ||= ::Elasticsearch::Model.client
    end
end
