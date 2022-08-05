# frozen_string_literal: true

class AddCountableToParticipants < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :countable, :boolean, default: true
  end
end
