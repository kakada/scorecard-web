# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                        :bigint           not null, primary key
#  uuid                      :string
#  unit_type_id              :integer
#  facility_id               :integer
#  name                      :string
#  description               :text
#  province_id               :string(2)
#  district_id               :string(4)
#  commune_id                :string(6)
#  year                      :integer
#  conducted_date            :datetime
#  number_of_caf             :integer
#  number_of_participant     :integer
#  number_of_female          :integer
#  planned_start_date        :datetime
#  planned_end_date          :datetime
#  status                    :integer
#  program_id                :integer
#  local_ngo_id              :integer
#  scorecard_type            :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  location_code             :string
#  number_of_disability      :integer
#  number_of_ethnic_minority :integer
#  number_of_youth           :integer
#  number_of_id_poor         :integer
#  creator_id                :integer
#  locked_at                 :datetime
#  primary_school_code       :string
#  downloaded_count          :integer          default(0)
#  progress                  :integer
#  language_conducted_code   :string
#  finished_date             :datetime
#  running_date              :datetime
#  deleted_at                :datetime
#  published                 :boolean          default(FALSE)
#  submitted_at              :datetime
#  completed_at              :datetime
#  device_type               :string
#  device_token              :string
#  completor_id              :integer
#
class ScorecardSerializer < ActiveModel::Serializer
  attributes :uuid, :unit_type_name, :facility_id, :scorecard_type,
             :name, :description, :location, :year, :conducted_date,
             :number_of_caf, :number_of_participant, :number_of_female,
             :number_of_disability, :number_of_ethnic_minority, :number_of_youth, :number_of_id_poor,
             :planned_start_date, :planned_end_date, :status,
             :program_id, :local_ngo_id, :local_ngo_name, :province, :district, :commune, :progress

  belongs_to :facility
  belongs_to :primary_school

  def unit_type_name
    object.unit_type.name
  end

  def local_ngo_name
    object.local_ngo.try(:name)
  end
end
