# frozen_string_literal: true

class DatasetSerializer < ActiveModel::Serializer
  attributes :id, :code, :name_en, :name_km, :province_id,
             :district_id, :commune_id, :category_id, :category_name_en, :category_name_km

  def category_name_en
    object.category&.name_en
  end

  def category_name_km
    object.category&.name_km
  end
end
