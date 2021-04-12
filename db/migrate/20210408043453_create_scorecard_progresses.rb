# frozen_string_literal: true

class CreateScorecardProgresses < ActiveRecord::Migration[6.0]
  def change
    create_table :scorecard_progresses do |t|
      t.string  :scorecard_uuid
      t.integer :status
      t.string  :device_id

      t.timestamps
    end
  end
end
