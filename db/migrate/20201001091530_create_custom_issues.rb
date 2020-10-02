# frozen_string_literal: true

class CreateCustomIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_issues do |t|
      t.integer :raised_persion_id
      t.text    :content
      t.string  :audio
      t.string  :tag

      t.timestamps
    end
  end
end
