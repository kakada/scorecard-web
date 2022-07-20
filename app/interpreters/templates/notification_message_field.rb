# frozen_string_literal: true

module Templates
  class NotificationMessageField
    def self.all
      [
        { name: "scorecard_code", code: "scorecard.code" },
        { name: "scorecard_type", code: "scorecard.scorecard_type" },
        { name: "facility", code: "scorecard.facility" },
        { name: "location", code: "scorecard.location_name" },
        { name: "lngo/implementer", code: "scorecard.local_ngo_name" },
        { name: "planned_start_date", code: "scorecard.planned_start_date" },
        { name: "planned_end_date", code: "scorecard.planned_end_date" },
        { name: "primary_caf_name", code: "facilitator.name" },
        { name: "running_date", code: "scorecard.running_date" },
        { name: "finished_date", code: "scorecard.finished_date" },
        { name: "submitted_date", code: "scorecard.submitted_date" },
        { name: "completed_date", code: "scorecard.completed_date" },
        { name: "today", code: "date.today" },
        { name: "scorecard_url", code: "scorecard.url" },
      ]
    end
  end
end
