module ActivityLogsHelper
  def format_label
    content_tag :span, class: "mr-2" do
      "#{t('activity_logs.http_format')}: "
    end
  end

  def method_label
    content_tag :span, class: "mr-2" do
      "#{t('activity_logs.http_method')}: "
    end
  end

  def duration_label
    content_tag :span, "#{t('activity_logs.duration')}: ", class: "mr-2"
  end

  def form_formats_collection
    [[t('shared.all'), ''], ['HTML','html'], ['JSON','json']] 
  end

  def form_methods_collection
    [[t('shared.all'), ''], ['GET', 'GET'], ['POST', 'POST'], ['PUT', 'PUT'], ['DELETE', 'DELETE']]
  end

  def read_more text, length = 100
    return text if text.length < length

    content_tag :div, data: { content: text } do
      new_content  = content_tag(:span, truncate(text, length: length), class: "content")
      new_content += "  "
      new_content += link_to t("activity_logs.more_html"), "#", class: "readme more"
      new_content += link_to t("activity_logs.less_html"), "#", class: "readme less", style: "display: none;"
    end
  end
end
