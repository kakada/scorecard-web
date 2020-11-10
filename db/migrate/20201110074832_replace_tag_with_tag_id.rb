# frozen_string_literal: true

class ReplaceTagWithTagId < ActiveRecord::Migration[6.0]
  def change
    remove_column :indicators, :tag
    remove_column :custom_indicators, :tag

    add_column :indicators, :tag_id, :integer
    add_column :custom_indicators, :tag_id, :integer
    add_column :raised_indicators, :tag_id, :integer
  end
end
