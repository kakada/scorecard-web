# frozen_string_literal: true

module ScorecardsHelper
  def scorecard_setup_sub_title
    return "" unless @scorecard.number_of_participant.present?

    str = "#{t('scorecard.participant')}: #{@scorecard.number_of_participant}, "
    str += "#{t('scorecard.female')}: #{@scorecard.number_of_female || 0}, "
    str += "#{t('scorecard.disability')}: #{@scorecard.number_of_disability || 0}, "
    str += "#{t('scorecard.minority')}: #{@scorecard.number_of_ethnic_minority || 0}, "
    str += "#{t('scorecard.youth')}: #{@scorecard.number_of_youth || 0}, "
    str += "#{t('scorecard.poor_card')}: #{@scorecard.number_of_id_poor || 0}"
    str
  end

  def scorecard_descriptions
    descriptions = ["<span><i class='fas fa-calendar-alt mr-1'></i>#{@scorecard.year}</span>"]
    descriptions.push(t("scorecard.#{@scorecard.scorecard_type}"))
    descriptions.push(@scorecard.facility_name)
    descriptions.push("<span><i class='fas fa-map-marker-alt mr-1'></i>#{scorecard_location(@scorecard)}</span>")
    descriptions.join(", ")
  end

  def scorecard_location(scorecard)
    return scorecard.location_name unless scorecard.primary_school.present?

    label = t("scorecard.primary_school")
    school_name = scorecard.primary_school_name
    primary_school = I18n.locale == :km ? "#{label}#{school_name}" : "#{school_name} #{label},"

    [primary_school, scorecard.location_name].join(" ")
  end

  def css_active_tab(is_active)
    return "active" if is_active
  end

  def status_html(scorecard)
    status_type = ["status", scorecard.status, "html"].compact.join("_")
    send(status_type, scorecard.status) rescue scorecard.status
  end

  def filter_date_options
    [
      { label: "Days ago", value: "Day" },
      { label: "Weeks ago", value: "Week" },
      { label: "Months ago", value: "Month" },
      { label: "Years ago", value: "Year" }
    ]
  end

  def date_html(date)
    return "" unless date.present?

    "<span><i class='fas fa-calendar-alt mr-1'></i>#{display_date(date)}</span>"
  end

  def setting_url
    return local_ngos_path if current_user.lngo?

    current_user.staff? ? facilities_path : languages_path
  end

  def swot_sub_title(scorecard)
    proposed_actions = scorecard.proposed_indicator_actions.suggested_action

    str = "#{t('scorecard.indicator_count', count: scorecard.voting_indicators.length)}"
    str += ", #{t('scorecard.suggested_action_count', count: proposed_actions.length)}"
    str += " <span class='badge badge-info'>#{t('scorecard.selected_action_count', count: proposed_actions.selecteds.length)}</span>"
    str.html_safe
  end
end
