# frozen_string_literal: true

module ScorecardsStatusesHelper
  def status_renewed_html(scorecard)
    content_tag :span, class: "badge badge-danger" do
      t("scorecard.renewed")
    end
  end

  def status_planned_html(scorecard)
    content_tag :span, class: "badge badge-secondary" do
      t("scorecard.planned")
    end
  end

  def status_running_html(scorecard)
    content_tag :span, class: "badge badge-warning" do
      t("scorecard.running")
    end
  end

  def status_in_review_html(scorecard)
    content_tag :span, class: "badge badge-info" do
      t("scorecard.in_review")
    end
  end

  def status_completed_html(scorecard)
    title = "<div class='text-left'>" +
            "<div>#{t('scorecard.completed_date')}: #{display_datetime(scorecard.completed_at)}</div>" +
            "<div>#{t('scorecard.completed_by')}: #{scorecard.completor_email}</div>" +
            "</div>"

    "<span data-toggle='tooltip' data-html='true' data-placement='top' title='#{sanitize(title)}'>" +
    "<span class='badge badge-success' >#{t('scorecard.completed')}</span>" +
    "<span>"
  end

  def status_downloaded_html(scorecard)
    content_tag :span, class: "badge badge-warning" do
      t("scorecard.downloaded")
    end
  end
end
