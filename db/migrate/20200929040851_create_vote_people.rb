# frozen_string_literal: true

class CreateVotePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :vote_people do |t|
      t.string  :scorecard_uuid
      t.string  :gender
      t.integer :age

      t.timestamps
    end
  end
end
