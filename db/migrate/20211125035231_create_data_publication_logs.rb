# frozen_string_literal: true

class CreateDataPublicationLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :data_publication_logs, id: :uuid do |t|
      t.integer  :program_id
      t.integer  :published_option

      t.timestamps
    end
  end
end
