# frozen_string_literal: true

class AddLanguageConductedCodeToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :language_conducted_code, :string
  end
end
