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
class Scorecard < ApplicationRecord
  belongs_to :unit_type, class_name: "Category"
  belongs_to :category
  belongs_to :local_ngo, optional: true
  belongs_to :program
  belongs_to :scorecard_type

  has_many   :scorecards_cafs
  has_many   :cafs, through: :scorecards_cafs
  has_many   :custom_indicators, foreign_key: :scorecard_uuid
  has_many   :raised_indicators, foreign_key: :scorecard_uuid
  has_many   :voting_indicators, foreign_key: :scorecard_uuid
  has_many   :ratings, foreign_key: :scorecard_uuid

  validates :year, presence: true
  validates :province_id, presence: true
  validates :district_id, presence: true
  validates :commune_id, presence: true
  validates :unit_type_id, presence: true
  validates :category_id, presence: true
  validates :scorecard_type_id, presence: true
  validates :local_ngo_id, presence: true

  before_create :secure_uuid
  before_create :set_name

  accepts_nested_attributes_for :scorecards_cafs, allow_destroy: true
  accepts_nested_attributes_for :raised_indicators, allow_destroy: true

  def location
    return if commune_id.nil?

    Pumi::Commune.find_by_id(commune_id).address_km
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
end
