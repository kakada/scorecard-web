# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def css_class_name
    "#{controller_path.parameterize}-#{action_name}"
  end

  def css_active_class(controller_name)
    return "active" if request.path.split("/")[1] == controller_name
  end

  def css_nested_active_class(controller_name)
    return "active" if params["controller"] == controller_name
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : "sortable"
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }, { class: css_class }
  end

  def render_notice
    content_tag(:div, notice, class: "alert alert-primary", role: "alert") if notice
  end

  def render_alert
    content_tag(:div, alert, class: "alert alert-danger", role: "alert") if alert
  end

  def link_to_add_fields(name, f, association, option = {})
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      partial = option[:partial].presence || association.to_s.singularize + "_fields"
      render(partial, f: builder, option: option)
    end

    link_to(name, "#", class: "add_field add_#{association} btn", data: { id: id, fields: fields.gsub("\n", "") })
  end

  def date_format(date)
    return unless date.present?

    format = current_program.try(:datetime_format) || Program::DATETIME_FORMATS.keys[0]
    date = Time.parse(date) if date.is_a?(String)
    date.strftime(Program::DATETIME_FORMATS[format])
  end

  def participant_information(criteria, agg_function)
    %w(female minority disability poor_card youth).map do |field|
      participant_tooltip(criteria, agg_function, field)
    end.compact.join(', ')
  end

  def timeago(date)
    return "" unless date.present?

    str = "<span class='timeago' data-date='#{l(date, format: :long)}'>"
    str += time_ago_in_words(date)
    str += "</span>"
    str
  end

  private
    def participant_tooltip(criteria, agg_function, field)
      value = criteria["#{field}_#{agg_function}"].to_i
      return unless value > 0

      tooltip_title = t("scorecard.#{field}")
      str = "<span data-toggle='tooltip' data-placement='top' title=#{tooltip_title}>"
      str += field == "female" ? "<i class='fas fa-venus'></i>: " : "<span class='text-uppercase'>#{field[0]}: </span>"
      str += "</span>"
      str += "<span>#{value}</span>"
      str
    end
end
