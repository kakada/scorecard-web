# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                    :bigint           not null, primary key
#  uuid                  :string
#  unit_type_id          :integer
#  category_id           :integer
#  name                  :string
#  description           :text
#  province_id           :string(2)
#  district_id           :string(4)
#  commune_id            :string(6)
#  year                  :integer
#  conducted_date        :datetime
#  number_of_caf         :integer
#  number_of_participant :integer
#  number_of_female      :integer
#  planned_start_date    :datetime
#  planned_end_date      :datetime
#  status                :integer
#  program_id            :integer
#  local_ngo_id          :integer
#  scorecard_type_id     :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class ScorecardSerializer < ActiveModel::Serializer
  attributes :uuid, :unit_type_name, :category_name, :scorecard_type_name, :category_id,
             :name, :description, :location, :year, :conducted_date,
             :number_of_caf, :number_of_participant, :number_of_female,
             :planned_start_date, :planned_end_date, :status, :scorecard_type_id,
             :program_id, :local_ngo_id, :local_ngo_name, :province, :district, :commune

  def unit_type_name
    object.unit_type.name
  end

  def category_name
    object.category.name
  end

  def scorecard_type_name
    object.scorecard_type.name
  end

  def local_ngo_name
    object.local_ngo.name
  end

  def commune
    _commune.name_km
  end

  def district
    _commune.district.name_km
  end

  def province
    _commune.province.name_km
  end

  private
    def _commune
      @_commune ||= Pumi::Commune.find_by_id(object.commune_id)
    end
end
