# frozen_string_literal: true

class AddFinishedDateOnAppToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :finished_date_on_app, :string
  end
end
