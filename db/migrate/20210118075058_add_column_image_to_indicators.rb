# frozen_string_literal: true

class AddColumnImageToIndicators < ActiveRecord::Migration[6.0]
  def change
    add_column :indicators, :image, :string
  end
end
