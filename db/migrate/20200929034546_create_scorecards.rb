# frozen_string_literal: true

class CreateScorecards < ActiveRecord::Migration[6.0]
  def change
    create_table :scorecards do |t|
      t.string   :uuid
      t.integer  :conducted_year
      t.datetime :conducted_date
      t.string   :province_code, limit: 2
      t.string   :district_code, limit: 4
      t.string   :commune_code, limit: 6
      t.integer  :category
      t.string   :sector
      t.integer  :number_of_caf
      t.integer  :number_of_participant
      t.integer  :number_of_female
      t.text     :caf_members

      t.timestamps
    end
  end
end
