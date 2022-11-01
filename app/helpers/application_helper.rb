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
  rescue
    nil
  end

  def participant_information(criteria, agg_function)
    %w(female minority disability poor_card youth).map do |field|
      participant_tooltip(criteria, agg_function, field)
    end.compact.join(", ")
  end

  def display_date(date)
    return "" unless date.present?

    format = current_program.try(:datetime_format) || Program::DATETIME_FORMATS.keys[0]
    format = format.downcase.split("-").join("_")

    I18n.l(date, format: :"#{format}")
  end

  def display_datetime(date)
    return "" unless date.present?

    format = current_program.try(:datetime_format) || Program::DATETIME_FORMATS.keys[0]
    format = format.downcase.split("-").join("_") + "_time"

    I18n.l(date, format: :"#{format}")
  end

  def timeago(date, type = "date")
    return "" unless date.present?

    dis_date = type == "date" ? display_date(date) : display_datetime(date)
    str = "<span class='timeago' data-date='#{dis_date}'>"
    str += time_ago_in_words(date)
    str += "</span>"
    str
  end

  def program_languages
    [
      { code: "km", label: I18n.t("language.km"), image: "khmer.png" },
      { code: "en", label: I18n.t("language.en"), image: "english.png" }
    ]
  end

  def form_check_toggle(option = {})
    disabled = option[:disabled].present? ? "disabled" : ""
    checked = option[:checked].present? ? "checked" : ""

    str = "<div class='form-check'>"
    str += "<label class='form-check-label form-check-toggle'>"
    str += "<input type='hidden' name='#{option[:name]}' value='0'/>"
    str += "<input type='checkbox' id='#{option[:id]}' name='#{option[:name]}' #{checked} #{disabled}/>"
    str += "<span>#{option[:label]}</span>"
    str += "</label>"
    str + "</div>"
  end

  def test_mode?
    !Rails.env.production?
  end

  private
    def participant_tooltip(criteria, agg_function, field)
      value = criteria["#{field}_#{agg_function}"].to_i
      return unless value > 0

      tooltip_title = t("scorecard.#{field}")
      str = "<span data-toggle='tooltip' data-placement='top' title=#{tooltip_title}>"
      str += I18n.t("scorecard.#{field}_shortcut") + ": #{value}"
      str + "</span>"
    end
end
