# frozen_string_literal: true

module ScorecardsStatusesHelper
  def status_renewed_html(scorecard)
    scorecard_progress = scorecard.scorecard_progresses.select { |sp| sp.status == "renewed" }.last

    title = "<div class='text-left'>" +
              "<div>#{t('scorecard.renewed_at')} #{display_datetime(scorecard_progress.created_at)}</div>" +
              "<div>#{t('scorecard.renewed_by')} #{scorecard_progress.user_email}</div>" +
            "</div>"

    wrap_in_tooltip(title, "renewed", "badge-danger")
  end

  def status_planned_html(scorecard)
    content_tag :span, class: "badge badge-secondary" do
      t("scorecard.planned")
    end
  end

  def status_running_html(scorecard)
    title = "<div class='text-left'>" +
            "<div>#{t('scorecard.running_at')} #{display_datetime(scorecard.running_date)}</div>" +
            "<div>#{t('scorecard.ran_by')} #{scorecard.runner_email}</div>" +
            "</div>"

    wrap_in_tooltip(title, scorecard.status, "badge-warning")
  end

  def status_in_review_html(scorecard)
    title = "<div class='text-left'>" +
            "<div>#{t('scorecard.in_review_at')} #{display_datetime(scorecard.submitted_at)}</div>" +
            "<div>#{t('scorecard.submitted_by')} #{scorecard.submitter_email}</div>" +
            "</div>"

    wrap_in_tooltip(title, scorecard.status, "badge-info")
  end

  def status_completed_html(scorecard)
    title = "<div class='text-left'>" +
              "<div>#{t('scorecard.completed_at')} #{display_datetime(scorecard.completed_at)}</div>" +
              "<div>#{t('scorecard.completed_by')} #{scorecard.completor_email}</div>" +
            "</div>"

    wrap_in_tooltip(title, scorecard.status, "badge-success")
  end

  def status_downloaded_html(scorecard)
    scorecard_progress = scorecard.scorecard_progresses.select { |sp| sp.status == "downloaded" }.last

    title = "<div class='text-left'>" +
              "<div>#{t('scorecard.download_at')} #{display_datetime(scorecard_progress.created_at)}</div>" +
              "<div>#{t('scorecard.download_by')} #{scorecard_progress.user_email}</div>" +
            "</div>"

    wrap_in_tooltip(title, "downloaded", "badge-warning")
  end

  private
    def wrap_in_tooltip(title, status, css_klass)
      "<span data-toggle='tooltip' data-html='true' data-placement='top' title='#{sanitize(title)}'>" +
      "<span class='badge #{css_klass}' > " + t("scorecard.#{status}") + "</span>" +
      "<span>"
    end
end
