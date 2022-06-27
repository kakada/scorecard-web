# frozen_string_literal: true

class CreateIndicatorActions < ActiveRecord::Migration[6.1]
  def change
    create_table :indicator_actions, id: :uuid do |t|
      t.string  :code
      t.string  :name
      t.boolean :predefined, default: true
      t.integer :kind
      t.string  :indicator_uuid

      t.timestamps
    end
  end
end
