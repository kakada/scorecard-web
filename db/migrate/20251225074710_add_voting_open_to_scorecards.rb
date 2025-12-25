# frozen_string_literal: true

class AddVotingOpenToScorecards < ActiveRecord::Migration[7.0]
  def change
    add_column :scorecards, :voting_open, :boolean, default: false
  end
end
