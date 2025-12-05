# frozen_string_literal: true

class AddHintToIndicators < ActiveRecord::Migration[7.0]
  def change
    add_column :indicators, :hint, :string
  end
end
