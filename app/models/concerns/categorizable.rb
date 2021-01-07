# frozen_string_literal: true

module Categorizable
  extend ActiveSupport::Concern

  included do
    has_many :indicators, as: :categorizable

    accepts_nested_attributes_for :indicators, allow_destroy: true, reject_if: ->(attributes) {
      attributes["name"].blank?
    }
  end
end
