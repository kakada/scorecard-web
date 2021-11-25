# frozen_string_literal: true

class AddOsmLatitudeToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :osm_latitude, :float
    add_column :locations, :osm_longitude, :float
  end
end
