# frozen_string_literal: true

class AddConductedAtToScorecardProgresses < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecard_progresses, :conducted_at, :datetime
  end
end
