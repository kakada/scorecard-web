# frozen_string_literal: true

class AddUuidToVotingIndicators < ActiveRecord::Migration[6.0]
  def change
    add_column :voting_indicators, :uuid, :string, default: "uuid_generate_v4()", null: false
    remove_column :voting_indicators, :id

    execute "ALTER TABLE voting_indicators ADD PRIMARY KEY (uuid);"
  end
end
