# frozen_string_literal: true

class AddEthnicAndIdPoorToRaisedPeople < ActiveRecord::Migration[6.0]
  def change
    add_column :raised_people, :ethnic_minority, :boolean
    add_column :raised_people, :id_poor, :boolean
  end
end
