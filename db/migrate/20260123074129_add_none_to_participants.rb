# frozen_string_literal: true

class AddNoneToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :none, :boolean, default: false
  end
end
