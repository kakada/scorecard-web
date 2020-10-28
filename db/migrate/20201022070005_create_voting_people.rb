# frozen_string_literal: true

class CreateVotingPeople < ActiveRecord::Migration[6.0]
  def change
    create_table :voting_people do |t|
      t.string  :scorecard_uuid
      t.string  :gender
      t.integer :age
      t.boolean :disability, default: false

      t.timestamps
    end
  end
end
