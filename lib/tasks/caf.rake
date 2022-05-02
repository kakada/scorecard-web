# frozen_string_literal: true

namespace :caf do
  desc "migrate scorecard knowledges"
  task migrate_scorecard_knowledges: :environment do
    Caf.where.not(scorecard_knowledge_id: nil).each do |caf|
      caf.update(scorecard_knowledge_ids: [caf.scorecard_knowledge_id])
    end
  end
end
