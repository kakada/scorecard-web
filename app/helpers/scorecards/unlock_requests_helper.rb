# frozen_string_literal: true

module Scorecards::UnlockRequestsHelper
  def unlock_popup_content(scorecard)
    sanitize(
      render(
        template: "scorecards/unlock_requests/popup",
        locals: { scorecard: scorecard }
      )
    )
  end

  def unlock_full_stop_class(scorecard)
    "bg-secondary" unless scorecard.unlock_requests.pendings.any?
  end
end
