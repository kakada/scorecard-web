# frozen_string_literal: true

class CreateUnlockRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :unlock_requests, id: :uuid do |t|
      t.integer  :scorecard_id
      t.integer  :proposer_id
      t.integer  :reviewer_id
      t.text     :reason
      t.text     :rejected_reason
      t.integer  :status
      t.datetime :resolved_date

      t.timestamps
    end

    add_index :unlock_requests, :scorecard_id
    add_index :unlock_requests, :proposer_id
    add_index :unlock_requests, :status
  end
end
