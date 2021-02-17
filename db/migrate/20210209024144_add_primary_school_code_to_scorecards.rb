# frozen_string_literal: true

class AddPrimarySchoolCodeToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :primary_school_code, :string
  end
end
