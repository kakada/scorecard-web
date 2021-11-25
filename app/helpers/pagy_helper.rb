# frozen_string_literal: true

module PagyHelper
  def pagy_bootstrap_compact_nav(pagy)
    render partial: "shared/bootstrap_nav", locals: { pagy: pagy }
  end
end
