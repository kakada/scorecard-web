# frozen_string_literal: true

class AddCategoryIdToFacilities < ActiveRecord::Migration[6.1]
  def change
    add_column :facilities, :category_id, :uuid
  end
end
