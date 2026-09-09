# frozen_string_literal: true

class AddRejectedAtToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :rejected_at, :datetime
  end
end
