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
    descriptions = ['year', 'location_name', 'facility_name', 'primary_school_name'].map { |method| @scorecard.send(method) }
    descriptions = descriptions.select{ |des| des.present? }
    descriptions.push(t("scorecard.#{@scorecard.scorecard_type}"))
    descriptions.join('; ')
  end

  def css_active_tab(is_active)
    return "active" if is_active
  end
end
