# frozen_string_literal: true

class AddSubsetToFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities, :subset, :string
  end
end
