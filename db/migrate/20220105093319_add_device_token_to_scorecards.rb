# frozen_string_literal: true

class AddDeviceTokenToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :device_token, :string
  end
end
