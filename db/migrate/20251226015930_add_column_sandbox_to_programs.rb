# frozen_string_literal: true

class AddColumnSandboxToPrograms < ActiveRecord::Migration[7.0]
  def change
    add_column :programs, :sandbox, :boolean, default: false, null: false
  end
end
