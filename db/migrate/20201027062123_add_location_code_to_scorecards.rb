# frozen_string_literal: true

class AddLocationCodeToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :location_code, :string
  end
end
