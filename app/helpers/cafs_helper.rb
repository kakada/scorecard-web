# frozen_string_literal: true

module CafsHelper
  def dob(date_str)
    return "" unless date_str.present?
    return display_warning(date_str) unless date_str.include? "-"

    date_format(date_str)
  rescue ArgumentError
    display_warning(date_str)
  end

  def scorecard_knowledges_html(caf)
    title = caf.scorecard_knowledges.map { |sk| "<div class='mb-2 text-left'>#{sk.name}</div>" }.join("")

    "<span data-toggle='tooltip' data-html='true' data-placement='top' title='#{sanitize(title)}'>" +
      caf.scorecard_knowledges.collect(&:"shortcut_name_#{I18n.locale}").join(", ") +
    "</span>"
  end

  private
    def display_warning(date_str)
      "#{date_str}<span data-toggle='tooltip' title=\'#{t('caf.dob_warning')}\'><i class='fas fa-info-circle ml-1 text-warning'></i></span>"
    end
end
