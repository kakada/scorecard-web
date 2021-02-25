# frozen_string_literal: true

class AddDefaultColumnToFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities, :default, :boolean, default: false
    add_column :facilities, :name_km, :string
    rename_column :facilities, :name, :name_en
    rename_column :facilities, :subset, :dataset
  end
end
