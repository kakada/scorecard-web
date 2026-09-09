# frozen_string_literal: true

class AddRejectedAtAndRejectedReasonToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :rejected_at, :datetime
    add_column :scorecards, :rejected_reason, :string
  end
end
