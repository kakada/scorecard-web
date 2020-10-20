# frozen_string_literal: true

class CreateRaisedIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :raised_indicators do |t|
      t.integer :indicatorable_id
      t.string  :indicatorable_type
      t.integer :raised_person_id
      t.string  :scorecard_uuid

      t.timestamps
    end
  end
end
