# frozen_string_literal: true

class AddNumberOfEthnicMinorityToScorecards < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :number_of_disability, :integer
    add_column :scorecards, :number_of_ethnic_minority, :integer
    add_column :scorecards, :number_of_youth, :integer
    add_column :scorecards, :number_of_id_poor, :integer
  end
end
