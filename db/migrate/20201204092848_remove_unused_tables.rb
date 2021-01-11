# frozen_string_literal: true

class RemoveUnusedTables < ActiveRecord::Migration[6.0]
  def change
    tables = ["raised_people", "vote_people", "voting_people"]

    tables.each do |table|
      drop_table table.to_sym if ActiveRecord::Base.connection.table_exists? table
    end
  end
end
