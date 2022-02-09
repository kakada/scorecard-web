# frozen_string_literal: true

module ScorecardsStatusesHelper
  def status_renewed_html(status)
    content_tag :span, class: "badge badge-danger" do
      t("scorecard.renewed")
    end
  end

  def status_planned_html(status)
    content_tag :span, class: "badge badge-secondary" do
      t("scorecard.planned")
    end
  end

  def status_running_html(status)
    content_tag :span, class: "badge badge-warning" do
      t("scorecard.running")
    end
  end

  def status_in_review_html(status)
    content_tag :span, class: "badge badge-info" do
      t("scorecard.in_review")
    end
  end

  def status_completed_html(status)
    content_tag :span, class: "badge badge-success" do
      t("scorecard.completed")
    end
  end

  def status_downloaded_html(status)
    content_tag :span, class: "badge badge-warning" do
      t("scorecard.downloaded")
    end
  end
end
