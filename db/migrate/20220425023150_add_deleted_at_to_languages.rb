# frozen_string_literal: true

class AddDeletedAtToLanguages < ActiveRecord::Migration[6.1]
  def change
    add_column :languages, :deleted_at, :datetime
    add_index :languages, :deleted_at
  end
end
