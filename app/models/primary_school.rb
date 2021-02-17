# frozen_string_literal: true

class PrimarySchool < ApplicationRecord
  validates :code, presence: true
  validates :name_km, presence: true
  validates :name_en, presence: true
  validates :commune_id, presence: true
end
