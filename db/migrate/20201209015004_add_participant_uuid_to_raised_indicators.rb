# frozen_string_literal: true

class AddParticipantUuidToRaisedIndicators < ActiveRecord::Migration[6.0]
  def change
    remove_column :raised_indicators, :raised_person_id
    add_column :raised_indicators, :participant_uuid, :string
  end
end
