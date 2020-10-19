# frozen_string_literal: true

class CreateRaisedIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :raised_indicators do |t|
      t.string  :scorecard_id
      t.integer :indicator_id

      t.timestamps
    end
  end
end
