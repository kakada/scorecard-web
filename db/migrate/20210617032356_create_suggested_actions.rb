# frozen_string_literal: true

class CreateSuggestedActions < ActiveRecord::Migration[6.0]
  def change
    create_table :suggested_actions do |t|
      t.string  :voting_indicator_uuid
      t.string  :content
      t.boolean :selected
      t.string  :scorecard_uuid
      t.timestamps
    end
  end
end
