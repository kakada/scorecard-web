# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.integer :contact_type
      t.string  :value
      t.integer :program_id

      t.timestamps
    end
  end
end
