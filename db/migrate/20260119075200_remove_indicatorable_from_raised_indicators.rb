# frozen_string_literal: true

class RemoveIndicatorableFromRaisedIndicators < ActiveRecord::Migration[6.0]
  def change
    remove_column :raised_indicators, :indicatorable_id, :integer
    remove_column :raised_indicators, :indicatorable_type, :string
  end
end
