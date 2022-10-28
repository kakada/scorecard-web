# frozen_string_literal: true

class AddDatasetIdToRequestChanges < ActiveRecord::Migration[6.1]
  def change
    add_column :request_changes, :dataset_id, :uuid
  end
end
