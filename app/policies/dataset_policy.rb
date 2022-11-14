# frozen_string_literal: true

class DatasetPolicy < CategoryPolicy
  def index?
    true
  end

  def public_view?
    !user.system_admin? && user.program.present? && user.program.dataset_categories.present?
  end
end
