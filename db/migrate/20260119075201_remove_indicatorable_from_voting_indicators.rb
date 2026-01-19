# frozen_string_literal: true

class RemoveIndicatorableFromVotingIndicators < ActiveRecord::Migration[6.0]
  def change
    remove_column :voting_indicators, :indicatorable_id, :integer
    remove_column :voting_indicators, :indicatorable_type, :string
  end
end
