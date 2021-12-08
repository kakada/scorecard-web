# frozen_string_literal: true

class CreateDataPublications < ActiveRecord::Migration[6.1]
  def change
    create_table :data_publications, id: :uuid do |t|
      t.integer  :program_id
      t.integer  :published_option

      t.timestamps
    end
  end
end
