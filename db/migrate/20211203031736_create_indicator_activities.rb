# frozen_string_literal: true

class CreateIndicatorActivities < ActiveRecord::Migration[6.1]
  def up
    create_table :indicator_activities, id: :uuid do |t|
      t.string  :voting_indicator_uuid
      t.string  :scorecard_uuid
      t.text    :content
      t.boolean :selected
      t.string  :type

      t.timestamps
    end

    # migrate weakness, strength, and suggest_actions to indicator activity
    Rake::Task["voting_indicator:migrate_indicator_activity"].invoke
  end

  def down
    drop_table :indicator_activities
  end
end
