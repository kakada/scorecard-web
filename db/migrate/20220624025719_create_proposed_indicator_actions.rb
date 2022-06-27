# frozen_string_literal: true

class CreateProposedIndicatorActions < ActiveRecord::Migration[6.1]
  def change
    create_table :proposed_indicator_actions, id: :uuid do |t|
      t.string  :voting_indicator_uuid
      t.uuid    :indicator_action_id
      t.string  :scorecard_uuid
      t.boolean :selected, default: false
      t.integer :kind

      t.timestamps
    end
  end
end
