# frozen_string_literal: true

class AddDeletedAtToCafs < ActiveRecord::Migration[6.0]
  def change
    add_column :cafs, :deleted_at, :datetime
    add_index :cafs, :deleted_at
  end
end
