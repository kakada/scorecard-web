# frozen_string_literal: true

class CreatePdfTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :pdf_templates do |t|
      t.string  :name
      t.text    :content
      t.string  :language_code
      t.integer :program_id

      t.timestamps
    end
  end
end
