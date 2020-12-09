class AddUuidToCustomIndicators < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_indicators, :uuid, :string
  end
end
