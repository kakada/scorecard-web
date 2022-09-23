# frozen_string_literal: true

class CreateDatasets < ActiveRecord::Migration[6.1]
  def change
    create_table :datasets, id: :uuid do |t|
      t.string :code
      t.string :name_en
      t.string :name_km
      t.string :category_id
      t.string :province_id
      t.string :district_id
      t.string :commune_id

      t.timestamps
    end
  end
end
