class AddUuidAndParticipantUuidToRatings < ActiveRecord::Migration[6.0]
  def change
    add_column :ratings, :uuid, :string, default: "uuid_generate_v4()", null: false
    add_column :ratings, :voting_indicator_uuid, :string
    add_column :ratings, :participant_uuid, :string

    remove_column :ratings, :id
    remove_column :ratings, :voting_indicator_id
    remove_column :ratings, :voting_person_id

    execute "ALTER TABLE ratings ADD PRIMARY KEY (uuid);"
  end
end
