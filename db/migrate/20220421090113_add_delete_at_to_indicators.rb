# frozen_string_literal: true

class AddDeleteAtToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :deleted_at, :datetime
    add_index :indicators, :deleted_at
  end
end
