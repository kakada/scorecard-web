# frozen_string_literal: true

class RemoveDesiredChangeFromVotingIndicators < ActiveRecord::Migration[6.0]
  def change
    remove_column :voting_indicators, :desired_change
  end
end
