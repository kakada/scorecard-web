# frozen_string_literal: true

module Indicatorable
  extend ActiveSupport::Concern

  included do
    has_many :raised_indicators, as: :indicatorable
    has_many :voting_indicators, as: :indicatorable
  end
end
