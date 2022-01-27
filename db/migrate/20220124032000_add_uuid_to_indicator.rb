# frozen_string_literal: true

class AddUuidToIndicator < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :uuid, :string
    add_column :indicators, :audio, :string
    add_column :indicators, :type, :string, default: "Indicators::PredefineIndicator"
    add_column :raised_indicators, :indicator_uuid, :string
    add_column :voting_indicators, :indicator_uuid, :string

    Rake::Task["indicator:migrate_uuid"].invoke
  end
end
