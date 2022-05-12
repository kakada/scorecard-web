# frozen_string_literal: true

class AddProposedIndicatorMethodToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :proposed_indicator_method, :integer, default: 1
  end
end
