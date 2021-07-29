# frozen_string_literal: true

class AddDistrictIdAndProvinceIdToPrimarySchools < ActiveRecord::Migration[6.0]
  def up
    add_column :primary_schools, :district_id, :string
    add_column :primary_schools, :province_id, :string

    Rake::Task["primary_school:migrate_location"].invoke
  end

  def down
    remove_column :primary_schools, :district_id
    remove_column :primary_schools, :province_id
  end
end
