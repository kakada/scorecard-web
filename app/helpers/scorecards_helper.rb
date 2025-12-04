# frozen_string_literal: true

module ScorecardsHelper
  def scorecard_setup_sub_title
    return "" unless @scorecard.number_of_participant.present?

    "#{t('scorecard.total_participant')}: " + participant_info(@scorecard)
  end

  def participant_info(scorecard)
    str = "#{@scorecard.number_of_participant} "
    str += "(#{t('scorecard.anonymous')} #{scorecard.number_of_anonymous}) - " if scorecard.number_of_anonymous.to_i.positive?
    str += "<small class='text-muted'>("
    str += "#{t('scorecard.female')}: #{scorecard.number_of_female || 0}, "
    str += "#{t('scorecard.disability')}: #{scorecard.number_of_disability || 0}, "
    str += "#{t('scorecard.minority')}: #{scorecard.number_of_ethnic_minority || 0}, "
    str += "#{t('scorecard.youth')}: #{scorecard.number_of_youth || 0}, "
    str += "#{t('scorecard.poor_card')}: #{scorecard.number_of_id_poor || 0}"
    str + ")</small>"
  end

  def indicator_development_sub_title(scorecard)
    indicator_description(t("scorecard.number_of_proposed_indicator"), scorecard.raised_indicators.map(&:indicator).uniq)
  end

  def voting_indicator_sub_title(scorecard)
    indicator_description(t("scorecard.number_of_selected_indicator"), scorecard.voting_indicators.map(&:indicator))
  end

  def scorecard_descriptions
    descriptions = ["<span><i class='fas fa-calendar-alt mr-1'></i>#{@scorecard.year}</span>"]
    descriptions.push("<span><i class='fas fa-map-marker-alt mr-1'></i>#{scorecard_location(@scorecard)}</span>")
    descriptions.join(", ")
  end

  def scorecard_location(scorecard)
    return "(#{scorecard.location_code}) #{scorecard.location_name}" unless scorecard.dataset.present?

    title = scorecard.dataset.category.name
    str = I18n.locale == :km ? "(#{scorecard.dataset_code}) #{title}#{scorecard.dataset_name}" : "(#{scorecard.dataset_code}) #{scorecard.dataset_name} #{title},"

    [str, scorecard.location_name].join(" ")
  end

  def css_active_tab(is_active)
    "active" if is_active
  end

  def status_html(scorecard)
    status_type = ["status", scorecard.status, "html"].compact.join("_")
    send(status_type, scorecard) rescue scorecard.status
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
    str = "#{t('scorecard.indicator_count', count: scorecard.voting_indicators.length)}"
    str += ", #{t('scorecard.suggested_action_count', count: scorecard.suggested_indicator_activities.length)}"
    str += " <span class='badge badge-info'>#{t('scorecard.selected_action_count', count: scorecard.suggested_indicator_activities.selecteds.count)}</span>"
    str.html_safe
  end

  def province_next_target(scorecard)
    return "district" if default_option(scorecard)

    scorecard.facility.category.hierarchy[1] || "dataset"
  end

  def dataset_filter_param(scorecard)
    return { commune_id: "FILTER" } if default_option(scorecard)

    param = {}
    param["#{scorecard.facility.category.hierarchy.last}_id"] = "FILTER"
    param[:category_id] = scorecard.facility.category_id
    param
  end

  def scorecard_progress_title(selected_count, limit_count, status)
    return t("scorecard.#{status}") unless selected_count > limit_count

    t("scorecard.#{status}") + " (#{t("scorecard.last_items", count: limit_count)}) :"
  end

  private
    def default_option(scorecard)
      scorecard.new_record? || scorecard.facility.nil? || scorecard.facility.category_id.nil?
    end

    def indicator_description(label, indicators)
      new_count = indicators.select { |indicator| indicator.custom? }.length

      str = "#{label}: #{indicators.length} "
      str += "<small class='text-muted'>(#{t('shared.new')}: #{new_count})</small>" if new_count.positive?
      str
    end
end
