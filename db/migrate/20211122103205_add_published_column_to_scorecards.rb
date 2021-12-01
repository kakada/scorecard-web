# frozen_string_literal: true

class AddPublishedColumnToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :published, :boolean, default: false
  end
end
