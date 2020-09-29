# frozen_string_literal: true

class CreatePredefinedIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :predefined_issues do |t|
      t.string :scorecard_uuid
      t.text   :content
      t.string :audio

      t.timestamps
    end
  end
end
