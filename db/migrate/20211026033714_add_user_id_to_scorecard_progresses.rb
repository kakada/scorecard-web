# frozen_string_literal: true

class AddUserIdToScorecardProgresses < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecard_progresses, :user_id, :integer
  end
end
