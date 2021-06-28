# frozen_string_literal: true

class AddShortcutNameToPrograms < ActiveRecord::Migration[6.0]
  def up
    add_column :programs, :shortcut_name, :string

    Rake::Task["program:migrate_shortcut_name"].invoke
  end

  def down
    remove_column :programs, :shortcut_name
  end
end
