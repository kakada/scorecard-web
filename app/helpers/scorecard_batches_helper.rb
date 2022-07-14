# frozen_string_literal: true

module ScorecardBatchesHelper
  def long_description(batch)
    t("scorecard_batch.display_items",
      total_scorecard: batch.total_item,
      total_valid: batch.total_valid,
      total_invalid: batch.total_item - batch.total_valid,
      total_province: batch.total_province,
      total_district: batch.total_district,
      total_commune: batch.total_commune
    )
  end

  def short_description(batch)
    t("scorecard_batch.short_description",
      total_item: batch.total_item,
      total_valid: batch.total_valid
    )
  end
end
