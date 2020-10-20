# frozen_string_literal: true

class CreateLocalNgos < ActiveRecord::Migration[6.0]
  def change
    create_table :local_ngos do |t|
      t.string   :name
      t.string   :province_id, limit: 2
      t.string   :district_id, limit: 4
      t.string   :commune_id, limit: 6
      t.string   :village_id, limit: 8
      t.string   :address
      t.integer  :program_id

      t.timestamps
    end
  end
end
