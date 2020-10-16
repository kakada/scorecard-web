class CreateLanguagesIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :languages_indicators do |t|
      t.integer :language_id
      t.string  :language_code
      t.integer :indicator_id
      t.string  :content
      t.string  :audio

      t.timestamps
    end
  end
end
