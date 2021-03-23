class CreatePdfTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :pdf_templates do |t|
      t.string  :name
      t.text    :content
      t.integer :program_id
      t.boolean :default

      t.timestamps
    end
  end
end
