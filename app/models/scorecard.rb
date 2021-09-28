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
#
class Scorecard < ApplicationRecord
  include Scorecards::Lockable
  include Scorecards::Location
  include Scorecards::Filter
  include Scorecards::CallbackNotification
  include Scorecards::Elasticsearch

  acts_as_paranoid if column_names.include? "deleted_at"

  enum scorecard_type: {
    self_assessment: 1,
    community_scorecard: 2
  }

  enum progress: ScorecardProgress.statuses

  SCORECARD_TYPES = scorecard_types.keys.map { |key| [I18n.t("scorecard.#{key}"), key] }

  belongs_to :unit_type, class_name: "Facility"
  belongs_to :facility
  belongs_to :local_ngo, optional: true
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid
  belongs_to :location, foreign_key: :location_code, optional: true
  belongs_to :creator, class_name: "User"
  belongs_to :primary_school, foreign_key: :primary_school_code, optional: true

  has_many   :facilitators, foreign_key: :scorecard_uuid, dependent: :destroy
  has_many   :cafs, through: :facilitators
  has_many   :participants, foreign_key: :scorecard_uuid, dependent: :destroy
  has_many   :custom_indicators, foreign_key: :scorecard_uuid, dependent: :destroy
  has_many   :raised_indicators, foreign_key: :scorecard_uuid, dependent: :destroy
  has_many   :voting_indicators, foreign_key: :scorecard_uuid, dependent: :destroy
  has_many   :ratings, foreign_key: :scorecard_uuid, dependent: :destroy
  has_many   :scorecard_progresses, foreign_key: :scorecard_uuid, primary_key: :uuid, dependent: :destroy
  has_many   :suggested_actions, foreign_key: :scorecard_uuid, primary_key: :uuid, dependent: :destroy
  has_many   :scorecard_references, foreign_key: :scorecard_uuid, primary_key: :uuid, dependent: :destroy

  delegate  :name, to: :local_ngo, prefix: :local_ngo, allow_nil: true
  delegate  :name_en, :name_km, to: :primary_school, prefix: :primary_school, allow_nil: true
  delegate  :name, to: :facility, prefix: :facility
  delegate  :name, to: :primary_school, prefix: :primary_school, allow_nil: true

  validates :year, presence: true
  validates :province_id, presence: true
  validates :district_id, presence: true
  validates :commune_id, presence: true
  validates :unit_type_id, presence: true
  validates :facility_id, presence: true
  validates :scorecard_type, presence: true
  validates :local_ngo_id, presence: true
  validates :primary_school_code, presence: true, if: -> { facility.try(:dataset).present? }

  validates :planned_start_date, presence: true
  validates :planned_end_date, presence: true, date: { after_or_equal_to: :planned_start_date }

  before_create :secure_uuid
  before_create :set_name
  before_save   :clear_primary_school_code, unless: -> { facility.try(:dataset).present? }

  after_commit  :index_document_async, on: [:create, :update]
  after_destroy :delete_document_async

  accepts_nested_attributes_for :facilitators, allow_destroy: true
  accepts_nested_attributes_for :participants, allow_destroy: true
  accepts_nested_attributes_for :raised_indicators, allow_destroy: true
  accepts_nested_attributes_for :voting_indicators, allow_destroy: true
  accepts_nested_attributes_for :ratings, allow_destroy: true

  def status
    completed? ? "completed" : "planned"
  end

  def completed?
    access_locked?
  end

  def renewed?
    progress == "renewed"
  end

  private
    def secure_uuid
      self.uuid ||= six_digit_rand

      return unless self.class.exists?(uuid: uuid)

      self.uuid = six_digit_rand
      secure_uuid
    end

    def six_digit_rand
      SecureRandom.random_number(1..999999).to_s.rjust(6, "0")
    end

    def set_name
      self.name = "#{location_code}-#{year}"
    end

    def clear_primary_school_code
      self.primary_school_code = nil
    end
end
