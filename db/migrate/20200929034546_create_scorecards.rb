# frozen_string_literal: true

class CreateScorecards < ActiveRecord::Migration[6.0]
  def change
    create_table :scorecards do |t|
      t.string   :uuid
      t.integer  :unit_type_id
      t.integer  :facility_id
      t.string   :name
      t.text     :description

      t.string   :province_id, limit: 2
      t.string   :district_id, limit: 4
      t.string   :commune_id, limit: 6

      t.integer  :year
      t.datetime :conducted_date

      t.integer  :number_of_caf
      t.integer  :number_of_participant
      t.integer  :number_of_female

      t.datetime :planned_start_date
      t.datetime :planned_end_date
      t.integer  :status
      t.integer  :program_id
      t.integer  :local_ngo_id
      t.integer  :scorecard_type

      t.timestamps
    end
  end
end
