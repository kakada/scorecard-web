class CreateVotingIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :voting_indicators do |t|
      t.integer :indicatorable_id
      t.string  :indicatorable_type
      t.string  :scorecard_uuid
      t.float   :median
      t.text    :strength
      t.text    :weakness
      t.text    :improvement
      t.text    :next_step

      t.timestamps
    end
  end
end
