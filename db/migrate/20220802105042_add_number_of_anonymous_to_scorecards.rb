# frozen_string_literal: true

class AddNumberOfAnonymousToScorecards < ActiveRecord::Migration[6.1]
  def change
    add_column :scorecards, :number_of_anonymous, :integer
  end
end
