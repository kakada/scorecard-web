class AddDisplayOrderToVotingIndicators < ActiveRecord::Migration[6.0]
  def change
    add_column :voting_indicators, :display_order, :integer
  end
end
