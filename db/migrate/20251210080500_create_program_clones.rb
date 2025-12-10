# frozen_string_literal: true

class CreateProgramClones < ActiveRecord::Migration[7.0]
  def up
    create_table :program_clones do |t|
      t.references :source_program, foreign_key: { to_table: :programs }, null: true
      t.references :target_program, foreign_key: { to_table: :programs }, null: false
      t.references :user, foreign_key: true, null: false
      t.text :selected_components, array: true, default: []
      t.string :clone_method, null: false # 'sample' or 'program'
      t.integer :status, default: 0 # pending, processing, completed, failed
      t.text :error_message
      t.datetime :completed_at

      t.timestamps
    end

    add_index :program_clones, :status
    add_index :program_clones, :clone_method
  end

  def down
    drop_table :program_clones
  end
end
