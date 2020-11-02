# frozen_string_literal: true

class AddDatetimeFormatToProgram < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :datetime_format, :string, default: "YYYY-MM-DD"
  end
end
