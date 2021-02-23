class AddNameKmToLanguages < ActiveRecord::Migration[6.0]
  def change
    rename_column :languages, :name, :name_en
    add_column :languages, :name_km, :string
  end
end
