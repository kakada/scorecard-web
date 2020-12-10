# frozen_string_literal: true

class CreateLanguageRatingScales < ActiveRecord::Migration[6.0]
  def change
    create_table :language_rating_scales do |t|
      t.integer :rating_scale_id
      t.integer :language_id
      t.string  :language_code
      t.string  :audio

      t.timestamps
    end
  end
end
