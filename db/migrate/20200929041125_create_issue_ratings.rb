# frozen_string_literal: true

class CreateIssueRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :issue_ratings do |t|
      t.integer :vote_issue_id
      t.integer :vote_person_id
      t.integer :score

      t.timestamps
    end
  end
end
