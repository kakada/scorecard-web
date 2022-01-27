# frozen_string_literal: true

class AddCompletorIdToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :completor_id, :integer
  end
end
