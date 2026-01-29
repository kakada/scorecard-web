# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                          :bigint           not null, primary key
#  uuid                        :string
#  unit_type_id                :integer
#  facility_id                 :integer
#  name                        :string
#  description                 :text
#  province_id                 :string(2)
#  district_id                 :string(4)
#  commune_id                  :string(6)
#  year                        :integer
#  conducted_date              :datetime
#  number_of_caf               :integer
#  number_of_participant       :integer
#  number_of_female            :integer
#  planned_start_date          :datetime
#  planned_end_date            :datetime
#  status                      :integer
#  program_id                  :integer
#  local_ngo_id                :integer
#  scorecard_type              :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  location_code               :string
#  number_of_disability        :integer
#  number_of_ethnic_minority   :integer
#  number_of_youth             :integer
#  number_of_id_poor           :integer
#  creator_id                  :integer
#  locked_at                   :datetime
#  primary_school_code         :string
#  downloaded_count            :integer          default(0)
#  progress                    :integer
#  language_conducted_code     :string
#  finished_date               :datetime
#  running_date                :datetime
#  deleted_at                  :datetime
#  published                   :boolean          default(FALSE)
#  device_type                 :string
#  submitted_at                :datetime
#  completed_at                :datetime
#  device_token                :string
#  completor_id                :integer
#  proposed_indicator_method   :integer          default("participant_based")
#  scorecard_batch_code        :string
#  number_of_anonymous         :integer
#  device_id                   :string
#  submitter_id                :integer
#  dataset_id                  :uuid
#  removing_scorecard_batch_id :uuid
#  runner_id                   :integer
#  app_version                 :integer
#  running_mode                :integer          default("online")
#  qr_code                     :string
#  token                       :string(64)
#
class ScorecardSerializer < ActiveModel::Serializer
  attributes :uuid, :unit_type_name, :facility_id, :scorecard_type,
             :name, :description, :location, :year, :conducted_date,
             :number_of_caf, :number_of_participant, :number_of_female,
             :number_of_disability, :number_of_ethnic_minority, :number_of_youth, :number_of_id_poor,
             :planned_start_date, :planned_end_date, :status, :program_uuid,
             :program_id, :local_ngo_id, :local_ngo_name, :province, :district, :commune, :progress,
             :program_scorecard_type, :running_mode

  belongs_to :facility
  belongs_to :primary_school
  belongs_to :dataset

  def unit_type_name
    object.unit_type.name
  end

  def local_ngo_name
    object.local_ngo.try(:name)
  end

  def program_uuid
    object.program.uuid
  end

  def program_scorecard_type
    return {} unless object.program_scorecard_type.present?

    ProgramScorecardTypeSerializer.new(object.program_scorecard_type)
  end
end
