# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def css_active_class(controller_name)
    return "active" if params["controller"].split("/")[0] == controller_name
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : "sortable"
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }, { class: css_class }
  end
end
