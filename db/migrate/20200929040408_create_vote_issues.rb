# frozen_string_literal: true

class CreateVoteIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :vote_issues do |t|
      t.string :scorecard_uuid
      t.string :content
      t.string :audio
      t.string :display_order

      t.timestamps
    end
  end
end
