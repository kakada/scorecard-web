class AddDisplayOrderToIndicators < ActiveRecord::Migration[6.0]
  def change
    add_column :indicators, :display_order, :integer
  end
end
