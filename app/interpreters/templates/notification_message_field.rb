# frozen_string_literal: true

module Templates
  class NotificationMessageField
    def self.all
      [
        { name: "scorecard_code", code: "scorecard.uuid" },
        { name: "scorecard_type", code: "scorecard.facility_name" },
        { name: "location", code: "scorecard.location_name" },
        { name: "lngo/implementer", code: "scorecard.local_ngo_name" },
        { name: "planned_start_date", code: "scorecard.planned_start_date" },
        { name: "planned_end_date", code: "scorecard.planned_end_date" },
        { name: "primary_caf_name", code: "facilitator.name" },
        { name: "finished_date_on_app", code: "scorecard.finished_date_on_app" },
      ]
    end
  end
end
