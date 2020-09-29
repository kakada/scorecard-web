# frozen_string_literal: true

class CreateRaisedIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :raised_issues do |t|
      t.string  :scorecard_uuid
      t.integer :raised_person_id
      t.text    :content
      t.string  :audio

      t.timestamps
    end
  end
end
