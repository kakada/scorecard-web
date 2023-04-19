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
#

class Scorecard < ApplicationRecord
  include Scorecards::Lockable
  include Scorecards::Location
  include Scorecards::Filter
  include Scorecards::CallbackNotification
  include Scorecards::Elasticsearch

  acts_as_paranoid if column_names.include? "deleted_at"

  # Enum field
  enum scorecard_type: {
    self_assessment: 1,
    community_scorecard: 2
  }

  enum progress: ScorecardProgress.statuses

  enum proposed_indicator_method: {
    participant_based: 1,
    indicator_based: 2
  }

  # Constant
  STATUS_COMPLETED = "completed"
  STATUS_IN_REVIEW = "in_review"
  STATUS_RUNNING = "running"
  SCORECARD_TYPES = scorecard_types.keys.map { |key| [I18n.t("scorecard.#{key}"), key] }

  # Association
  belongs_to :unit_type, class_name: "Facility"
  belongs_to :facility
  belongs_to :local_ngo, optional: true
  belongs_to :program
  belongs_to :location, foreign_key: :location_code, optional: true
  belongs_to :creator, class_name: "User"
  belongs_to :submitter, class_name: "User", optional: true
  belongs_to :completor, class_name: "User", optional: true
  belongs_to :primary_school, foreign_key: :primary_school_code, optional: true
  belongs_to :language, foreign_key: :language_conducted_code, primary_key: :code, optional: true
  belongs_to :scorecard_batch, foreign_key: :scorecard_batch_code, primary_key: :code, optional: true
  belongs_to :removing_scorecard_batch, optional: true
  belongs_to :dataset, optional: true

  has_many   :facilitators, foreign_key: :scorecard_uuid
  has_many   :cafs, through: :facilitators
  has_many   :participants, foreign_key: :scorecard_uuid
  has_many   :custom_indicators, foreign_key: :scorecard_uuid
  has_many   :raised_indicators, foreign_key: :scorecard_uuid
  has_many   :voting_indicators, foreign_key: :scorecard_uuid
  has_many   :ratings, foreign_key: :scorecard_uuid
  has_many   :scorecard_progresses, foreign_key: :scorecard_uuid, primary_key: :uuid
  has_many   :suggested_actions, foreign_key: :scorecard_uuid, primary_key: :uuid
  has_many   :scorecard_references, foreign_key: :scorecard_uuid, primary_key: :uuid
  has_many   :request_changes, foreign_key: :scorecard_uuid, primary_key: :uuid

  has_many   :indicator_activities, foreign_key: :scorecard_uuid, primary_key: :uuid
  has_many   :strength_indicator_activities, foreign_key: :scorecard_uuid, primary_key: :uuid
  has_many   :weakness_indicator_activities, foreign_key: :scorecard_uuid, primary_key: :uuid
  has_many   :suggested_indicator_activities, foreign_key: :scorecard_uuid, primary_key: :uuid

  # Delegation
  delegate  :name, :code, to: :local_ngo, prefix: :local_ngo, allow_nil: true
  delegate  :name_en, :name_km, to: :primary_school, prefix: :primary_school, allow_nil: true
  delegate  :name, to: :facility, prefix: :facility, allow_nil: true
  delegate  :name, to: :primary_school, prefix: :primary_school, allow_nil: true
  delegate  :name, :code, to: :dataset, prefix: :dataset, allow_nil: true
  delegate  :email, to: :completor, prefix: :completor, allow_nil: true

  # Validation
  validates :year, presence: true
  validates :province_id, presence: true
  validates :district_id, presence: true, if: -> { facility.try(:category_id).nil? || facility.category.hierarchy.include?("district") }
  validates :commune_id, presence: true, if: -> { facility.try(:category_id).nil? || facility.category.hierarchy.include?("commune") }
  validates :unit_type_id, presence: true
  validates :facility_id, presence: true
  validates :scorecard_type, presence: true, inclusion: { in: scorecard_types.keys }
  validates :local_ngo_id, presence: true
  validates :dataset_id, presence: true, if: -> { facility.try(:category_id).present? }

  validates :planned_start_date, presence: true
  validates :planned_end_date, presence: true, date: { after_or_equal_to: :planned_start_date }

  validates :submitter_id, presence: true, if: -> { submitted_at.present? }
  validates :completor_id, presence: true, if: -> { completed_at.present? }

  # Callback
  before_create :secure_uuid
  before_create :set_name
  before_create :set_published
  before_save   :clear_dataset_id, unless: -> { facility.try(:category_id).present? }
  before_save   :set_primary_school_code

  after_commit  :create_submitted_progress, on: [:update], if: -> { saved_change_to_progress? && in_review? }
  after_commit  :create_completed_progress, on: [:update], if: -> { saved_change_to_progress? && completed? }
  after_commit  :index_document_async, on: [:create, :update], if: -> { ENV["ELASTICSEARCH_ENABLED"] == "true" }
  after_destroy :delete_document_async, if: -> { ENV["ELASTICSEARCH_ENABLED"] == "true" }

  # Nested Attribute
  accepts_nested_attributes_for :facilitators, allow_destroy: true
  accepts_nested_attributes_for :participants, allow_destroy: true
  accepts_nested_attributes_for :raised_indicators, allow_destroy: true
  accepts_nested_attributes_for :voting_indicators, allow_destroy: true
  accepts_nested_attributes_for :ratings, allow_destroy: true

  # Scope
  scope :completeds, -> { where.not(completed_at: nil) }
  scope :lockeds, -> { where.not(locked_at: nil) }

  def status
    progress.present? ? progress : "planned"
  end

  # Class method
  def self.t_scorecard_types
    self.scorecard_types.keys.map { |key| [I18n.t("scorecard.#{key}"), key] }
  end

  def t_scorecard_type
    program_scorecard_type.try(:name) || I18n.t("scorecard.#{scorecard_type}")
  end

  def program_scorecard_type
    @program_scorecard_type ||= program.program_scorecard_types.select { |ty| ty.code == scorecard_type }.first
  end

  def self.statuses
    ["planned"] + self.progresses.keys
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

    def set_published
      self.published = program.data_publication.present? && !program.data_publication.stop_publish_data?
    end

    def clear_dataset_id
      self.dataset_id = nil
      self.primary_school_code = nil
    end

    def create_submitted_progress
      scorecard_progresses.create(status: STATUS_IN_REVIEW, device_id: device_id, user_id: submitter_id)
    end

    def create_completed_progress
      scorecard_progresses.create(status: STATUS_COMPLETED, user_id: completor_id)
    end

    def set_primary_school_code
      return unless dataset_id.present? && facility.try(:category_code) == "DS_PS"

      self.primary_school_code = PrimarySchool.find_by(code: dataset_code).try(:id)
    end
end
