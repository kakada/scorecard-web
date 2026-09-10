# frozen_string_literal: true

class FamReportingStat < ApplicationRecord
  enum source: { web: 0, mobile: 1 }

  validates :source, presence: true
  validates :views_count, numericality: { greater_than_or_equal_to: 0 }

  def self.record_view!(source)
    stat = create_or_find_by!(source: source) do |record|
      record.views_count = 0
    end

    increment_counter(:views_count, stat.id)
    find(stat.id)
  end
end
