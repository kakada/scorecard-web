module ScorecardsStatusesHelper
  def status_planned_renewed_html(status)
    content_tag :span, class: "badge badge-danger" do
      "#{status} (#{t('scorecard.renewed')})"
    end
  end

  def status_planned_html(status)
    content_tag :span, class: "badge badge-warning" do
      status
    end
  end

  def status_planned_running_html(status)
    content_tag :span, class: "badge badge-warning" do
      "#{status} (#{t('scorecard.running')})"
    end
  end

  def status_completed_submitted_html(status)
    content_tag :span, class: "badge badge-success" do
      "#{status} (#{t('scorecard.submitted')})"
    end
  end
end
