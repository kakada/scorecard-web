# frozen_string_literal: true

class AddLocaleToGfDashboards < ActiveRecord::Migration[6.0]
  def up
    add_column :gf_dashboards, :locale, :string, null: false, default: "km"
    add_index :gf_dashboards, [:program_id, :locale], unique: true
  end

  def down
    remove_index :gf_dashboards, [:program_id, :locale]
    remove_column :gf_dashboards, :locale
  end
end
