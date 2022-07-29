# frozen_string_literal: true

class AddUuidToPrograms < ActiveRecord::Migration[6.1]
  def change
    add_column :programs, :uuid, :string
  end
end
