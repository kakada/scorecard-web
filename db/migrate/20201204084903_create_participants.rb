class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.string  :uuid
      t.string  :scorecard_uuid
      t.integer :age
      t.string  :gender
      t.boolean :disability, default: false
      t.boolean :minority, default: false
      t.boolean :poor_card, default: false
      t.boolean :youth, default: false

      t.timestamps
    end
  end
end
