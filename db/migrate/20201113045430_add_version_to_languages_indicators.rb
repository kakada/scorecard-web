# frozen_string_literal: true

class AddVersionToLanguagesIndicators < ActiveRecord::Migration[6.0]
  def change
    add_column :languages_indicators, :version, :integer, default: 0
  end
end
