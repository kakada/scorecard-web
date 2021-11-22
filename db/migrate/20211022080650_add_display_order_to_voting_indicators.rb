# frozen_string_literal: true

class AddDisplayOrderToVotingIndicators < ActiveRecord::Migration[6.0]
  def up
    add_column :voting_indicators, :display_order, :integer

    Rake::Task["voting_indicator:migrate_display_order"].invoke
  end

  def down
    remove_column :voting_indicators, :display_order
  end
end
