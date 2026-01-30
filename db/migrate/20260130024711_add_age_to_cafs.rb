# frozen_string_literal: true

class AddAgeToCafs < ActiveRecord::Migration[7.0]
  def change
    add_column :cafs, :age, :integer
  end
end
