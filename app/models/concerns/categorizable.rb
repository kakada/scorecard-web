# frozen_string_literal: true

module Categorizable
  extend ActiveSupport::Concern

  included do
    has_many :indicators, as: :categorizable
  end
end
