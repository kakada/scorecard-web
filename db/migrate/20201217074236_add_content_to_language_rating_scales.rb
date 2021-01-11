# frozen_string_literal: true

class AddContentToLanguageRatingScales < ActiveRecord::Migration[6.0]
  def change
    add_column :language_rating_scales, :content, :string
  end
end
