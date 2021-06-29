# frozen_string_literal: true

class CreateMobileTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :mobile_tokens do |t|
      t.string   :token
      t.integer  :program_id

      t.timestamps
    end
  end
end
