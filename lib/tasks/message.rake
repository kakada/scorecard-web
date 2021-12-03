# frozen_string_literal: true

namespace :message do
  desc "migrate milestone completed"
  task migrate_milestone_submitted_to_in_review: :environment do
    messages = Message.where(milestone: "submitted")
    messages.update(milestone: "in_review")
  end
end
