# frozen_string_literal: true

class AddShortNameToLocalNgos < ActiveRecord::Migration[7.0]
  def change
    add_column :local_ngos, :short_name, :string
  end
end
