# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def css_active_class(controller_name)
    return 'active' if params['controller'].split('/')[0] == controller_name
  end
end
