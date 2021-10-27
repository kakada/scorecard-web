# frozen_string_literal: true

module ScorecardsStatusesHelper
  def status_planned_renewed_html(status)
    content_tag :span, class: "badge badge-danger" do
      t("scorecard.renewed")
    end
  end

  def status_planned_html(status)
    content_tag :span, class: "badge badge-warning" do
      t("scorecard.planned")
    end
  end

  def status_planned_running_html(status)
    content_tag :span, class: "badge badge-warning" do
      t("scorecard.running")
    end
  end

  def status_completed_submitted_html(status)
    content_tag :span, class: "badge badge-success" do
      t("scorecard.completed")
    end
  end

  def status_planned_downloaded_html(status)
    content_tag :span, class: "badge badge-warning" do
      t("scorecard.downloaded")
    end
  end
end
