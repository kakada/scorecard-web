# frozen_string_literal: true

class CreateRequestChanges < ActiveRecord::Migration[6.1]
  def change
    create_table :request_changes, id: :uuid do |t|
      t.string   :scorecard_uuid
      t.integer  :proposer_id
      t.integer  :reviewer_id
      t.string   :year
      t.integer  :scorecard_type
      t.string   :province_id
      t.string   :district_id
      t.string   :commune_id
      t.string   :primary_school_code
      t.text     :changed_reason
      t.text     :rejected_reason
      t.integer  :status
      t.datetime :resolved_date

      t.timestamps
    end
  end
end
