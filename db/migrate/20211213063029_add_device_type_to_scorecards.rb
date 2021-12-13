# frozen_string_literal: true

class AddDeviceTypeToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :device_type, :string
  end
end
