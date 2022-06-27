# frozen_string_literal: true

module IndicatorActions::Removing
  extend ActiveSupport::Concern

  included do
    def remove!
      return if locked?

      self.destroy
    end

    def locked?
      proposed_indicator_actions.present?
    end
  end
end
