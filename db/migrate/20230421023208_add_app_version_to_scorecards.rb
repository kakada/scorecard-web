# frozen_string_literal: true

class AddAppVersionToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :app_version, :integer
  end
end
