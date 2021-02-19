# frozen_string_literal: true

class AddLockedAtToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :locked_at, :datetime
  end
end
