# frozen_string_literal: true

class DatasetSerializer < ActiveModel::Serializer
  attributes :id, :code, :name_en, :name_km, :province_id,
             :district_id, :commune_id, :category_id, :category_name

  def category_name
    object.category&.name
  end
end
