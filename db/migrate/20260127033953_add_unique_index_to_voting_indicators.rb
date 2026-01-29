# frozen_string_literal: true

class AddUniqueIndexToVotingIndicators < ActiveRecord::Migration[7.0]
  def up
    add_index :voting_indicators, [:scorecard_uuid, :indicator_uuid], unique: true
  end

  def down
    remove_index :voting_indicators, column: [:scorecard_uuid, :indicator_uuid]
  end
end
