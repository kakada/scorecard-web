module ActivityLogsHelper
  def form_formats_collection
    [[t('activity_logs.format'), ''], ['HTML','html'], ['JSON','json']] 
  end

  def form_methods_collection
    [[t('activity_logs.method'), ''], ['GET', 'GET'], ['POST', 'POST'], ['PUT', 'PUT'], ['DELETE', 'DELETE']]
  end
end
