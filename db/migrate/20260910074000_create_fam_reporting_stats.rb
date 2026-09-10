# frozen_string_literal: true

class CreateFamReportingStats < ActiveRecord::Migration[7.0]
  def change
    create_table :fam_reporting_stats do |t|
      t.integer :source, null: false
      t.integer :views_count, null: false, default: 0

      t.timestamps
    end

    add_index :fam_reporting_stats, :source, unique: true
  end
end
