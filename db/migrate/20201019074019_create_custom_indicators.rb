class CreateCustomIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_indicators do |t|
      t.string :name
      t.string :audio
      t.string :tag
      t.string :scorecard_uuid

      t.timestamps
    end
  end
end
