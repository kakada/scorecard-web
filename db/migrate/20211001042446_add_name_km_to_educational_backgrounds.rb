# frozen_string_literal: true

class AddNameKmToEducationalBackgrounds < ActiveRecord::Migration[6.0]
  def change
    rename_column :educational_backgrounds, :name, :name_en
    add_column :educational_backgrounds, :name_km, :string
  end
end
