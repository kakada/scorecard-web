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
    descriptions = ["year", "facility_name"].map { |method| @scorecard.send(method) }
    descriptions.push(t("scorecard.#{@scorecard.scorecard_type}"))
    descriptions.push(scorecard_location(@scorecard))
    descriptions.join("; ")
  end

  def scorecard_location(scorecard)
    str = [scorecard.location_name]

    if primary_school = scorecard.send("primary_school_name_#{I18n.locale}").presence
      str.unshift("#{t('scorecard.primary_school')}#{primary_school}")
    end

    str.join(" ")
  end

  def css_active_tab(is_active)
    return "active" if is_active
  end

  def status_html(scorecard)
    css_klass = scorecard.completed? ? "badge-success" : "badge-warning"
    "<span class='badge #{css_klass}'>#{scorecard.status}</span>"
  end
end
