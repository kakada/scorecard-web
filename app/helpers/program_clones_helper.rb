# frozen_string_literal: true

module ProgramClonesHelper
  def status_class(status)
    css_class = {
      pending: "info",
      processing: "warning",
      completed: "success",
      failed: "danger"
    }
    css_class[status.to_sym] || "secondary"
  end

  def status_icon(status)
    icon_class = {
      pending: "fas fa-clock text-warning",
      processing: "fas fa-spinner fa-spin text-primary",
      completed: "fas fa-check-circle text-success",
      failed: "fas fa-exclamation-triangle text-danger"
    }

    content_tag(:i, "", class: icon_class[status.to_sym])
  end

  def available_programs
    Program.where.not(id: @program.id).order(:name)
  end
end
