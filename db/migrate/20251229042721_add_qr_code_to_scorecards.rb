# frozen_string_literal: true

class AddQrCodeToScorecards < ActiveRecord::Migration[7.0]
  def change
    add_column :scorecards, :qr_code, :string
  end
end
