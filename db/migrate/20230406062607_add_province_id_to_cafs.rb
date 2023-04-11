# frozen_string_literal: true

class AddProvinceIdToCafs < ActiveRecord::Migration[6.1]
  def change
    add_column :cafs, :province_id, :string
    add_column :cafs, :district_id, :string
    add_column :cafs, :commune_id, :string
  end
end
