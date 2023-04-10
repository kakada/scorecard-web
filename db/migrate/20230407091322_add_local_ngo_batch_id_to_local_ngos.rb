# frozen_string_literal: true

class AddLocalNgoBatchIdToLocalNgos < ActiveRecord::Migration[6.1]
  def change
    add_column :local_ngos, :local_ngo_batch_id, :uuid
  end
end
