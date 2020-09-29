# frozen_string_literal: true

class CreateSwots < ActiveRecord::Migration[6.0]
  def change
    create_table :swots do |t|
      t.string  :scorecard_uuid
      t.integer :voting_issue_id
      t.integer :display_order
      t.text    :strength
      t.text    :weakness
      t.text    :improvement
      t.text    :activity
      t.float   :rating_median_score
      t.string  :rating_result

      t.timestamps
    end
  end
end
