# frozen_string_literal: true

module ActivityLogsHelper
  def http_format_label
    content_tag :span, "#{t('activity_logs.http_format')}: ", class: "mr-2"
  end

  def http_method_label
    content_tag :span, "#{t('activity_logs.http_method')}: ", class: "mr-2"
  end

  def duration_label
    content_tag :span, "#{t('activity_logs.duration')}: ", class: "mr-2"
  end

  def form_formats_collection
    [[t("shared.all"), ""], ["HTML", "html"], ["JSON", "json"]]
  end

  def form_methods_collection
    [[t("shared.all"), ""], ["GET", "GET"], ["POST", "POST"], ["PUT", "PUT"], ["DELETE", "DELETE"]]
  end

  def read_more(orig_text, max_length = 100)
    return orig_text if orig_text.length < max_length

    content_tag :div, data: { content: orig_text } do
      ellipsis  = content_tag(:span, truncate(orig_text, length: max_length), class: "content")
      ellipsis += link_to_read_more
      ellipsis + link_to_read_less
    end
  end

  def link_to_read_more
    link_to t("activity_logs.more_html"), "#", class: "readme more"
  end

  def link_to_read_less(style = "display: none;")
    link_to t("activity_logs.less_html"), "#", class: "readme less", style: style
  end
end
