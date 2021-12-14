# frozen_string_literal: true

class AddReferenceForRaisedIndicatorsAndVotingIndicators < ActiveRecord::Migration[6.1]
  def up
    add_column :raised_indicators, :selected, :boolean, default: false
    add_column :raised_indicators, :voting_indicator_uuid, :string

    Rake::Task["voting_indicator:migrate_reference_with_raised_indicator"].invoke
  end

  def down
    remove_column :raised_indicators, :selected
    remove_column :raised_indicators, :voting_indicator_uuid
  end
end
