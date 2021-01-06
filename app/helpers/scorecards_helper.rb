# frozen_string_literal: true

module ScorecardsHelper
  def scorecard_setup_sub_title
    return '' unless @scorecard.number_of_participant.present?

    str = "#{t('scorecard.number_of_participant')}: #{@scorecard.number_of_participant}; "
    str += "#{t('scorecard.number_of_female')}: #{@scorecard.number_of_female || 0}; "
    str += "#{t('scorecard.number_of_disability')}: #{@scorecard.number_of_disability || 0}; "
    str += "#{t('scorecard.number_of_ethnic_minority')}: #{@scorecard.number_of_ethnic_minority || 0}; "
    str += "#{t('scorecard.number_of_youth')}: #{@scorecard.number_of_youth || 0}; "
    str += "#{t('scorecard.number_of_id_poor')}: #{@scorecard.number_of_id_poor || 0}; "
    str
  end
end
