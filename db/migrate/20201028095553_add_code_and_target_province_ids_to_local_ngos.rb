# frozen_string_literal: true

class AddCodeAndTargetProvinceIdsToLocalNgos < ActiveRecord::Migration[6.0]
  def change
    add_column :local_ngos, :code, :string
    add_column :local_ngos, :target_province_ids, :string
    remove_column :local_ngos, :address
  end
end
