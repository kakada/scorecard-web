# frozen_string_literal: true

# == Schema Information
#
# Table name: datasets
#
#  id          :uuid             not null, primary key
#  code        :string
#  name_en     :string
#  name_km     :string
#  category_id :string
#  province_id :string
#  district_id :string
#  commune_id  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class DatasetSerializer < ActiveModel::Serializer
  attributes :id, :code, :name_en, :name_km, :province_id,
             :district_id, :commune_id, :category_id, :category_name_en, :category_name_km

  belongs_to :category

  def category_name_en
    object.category&.name_en
  end

  def category_name_km
    object.category&.name_km
  end
end
