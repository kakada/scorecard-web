# frozen_string_literal: true

class AddDeletedAtToLocalNgos < ActiveRecord::Migration[6.1]
  def change
    add_column :local_ngos, :deleted_at, :datetime
    add_index :local_ngos, :deleted_at
  end
end
