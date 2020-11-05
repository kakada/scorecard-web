# frozen_string_literal: true

class CreateVotingIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :voting_indicators do |t|
      t.integer :indicatorable_id
      t.string  :indicatorable_type
      t.string  :scorecard_uuid
      t.integer :median
      t.text    :strength
      t.text    :weakness
      t.text    :desired_change
      t.text    :suggested_action

      t.timestamps
    end
  end
end
