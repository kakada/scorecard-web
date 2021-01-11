# frozen_string_literal: true

class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants, id: false do |t|
      t.primary_key :uuid, :string
      t.string  :scorecard_uuid
      t.integer :age
      t.string  :gender
      t.boolean :disability, default: false
      t.boolean :minority, default: false
      t.boolean :poor_card, default: false
      t.boolean :youth, default: false

      t.timestamps
    end
  end
end
