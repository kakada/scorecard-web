# frozen_string_literal: true

class AddDeviceSubmissionTokenToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :device_submission_token, :string
    add_index :participants, [:scorecard_uuid, :device_submission_token], name: "index_participants_on_scorecard_uuid_and_device_token"
  end
end
