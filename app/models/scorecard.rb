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
#
class Scorecard < ApplicationRecord
  include Lockable

  belongs_to :unit_type, class_name: "Facility"
  belongs_to :facility
  belongs_to :local_ngo, optional: true
  belongs_to :program
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

  delegate  :name, to: :local_ngo, prefix: :local_ngo, allow_nil: true
  delegate  :name_en, :name_km, to: :primary_school, prefix: :primary_school, allow_nil: true
  delegate  :name, to: :facility, prefix: :facility

  validates :year, presence: true
  validates :province_id, presence: true
  validates :district_id, presence: true
  validates :commune_id, presence: true
  validates :unit_type_id, presence: true
  validates :facility_id, presence: true
  validates :scorecard_type, presence: true
  validates :local_ngo_id, presence: true
  validates :primary_school_code, presence: true, if: -> { facility.try(:subset).present? }
  validates :primary_school_code, uniqueness: { scope: :commune_id }, allow_nil: true
  validates :planned_start_date, presence: true
  validates :planned_end_date, presence: true, date: { after_or_equal_to: :planned_start_date }

  before_validation :set_location_code

  before_create :secure_uuid
  before_create :set_name
  before_save   :clear_primary_school_code, unless: -> { facility.try(:subset).present? }

  accepts_nested_attributes_for :facilitators, allow_destroy: true
  accepts_nested_attributes_for :participants, allow_destroy: true
  accepts_nested_attributes_for :raised_indicators, allow_destroy: true
  accepts_nested_attributes_for :voting_indicators, allow_destroy: true
  accepts_nested_attributes_for :ratings, allow_destroy: true

  enum scorecard_type: {
    self_assessment: 1,
    community_scorecard: 2
  }

  SCORECARD_TYPES = scorecard_types.keys.map { |key| [I18n.t("scorecard.#{key}"), key] }

  def location_name(address = "address_km")
    return if location_code.blank?

    "Pumi::#{Location.location_kind(location_code).titlecase}".constantize.find_by_id(location_code).try("#{address}".to_sym)
  end

  def status
    !!locked_at ? "completed" : "planned"
  end

  def self.filter(params)
    scope = all
    scope = scope.where.not(locked_at: nil) if params[:locked].present?
    scope = scope.where(locked_at: nil) if params[:planned].present?
    scope
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
      self.name = "#{commune_id}-#{year}-#{unit_type_id.to_s.rjust(2, '0')}"
    end

    def set_location_code
      self.location_code = commune_id
    end

    def clear_primary_school_code
      self.primary_school_code = nil
    end
end
