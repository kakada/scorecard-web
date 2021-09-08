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
end
