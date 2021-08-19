class AddActivedToCafs < ActiveRecord::Migration[6.0]
  def change
    add_column :cafs, :actived, :boolean, default: true
  end
end
