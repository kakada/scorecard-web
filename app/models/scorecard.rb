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
#  address               :string
#  lat                   :string
#  lng                   :string
#  conducted_date        :datetime
#  number_of_caf         :integer
#  number_of_participant :integer
#  number_of_female      :integer
#  planned_start_date    :datetime
#  planned_end_date      :datetime
#  status                :integer
#  program_id            :integer
#  local_ngo_id          :integer
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
  has_many   :raised_indicators, foreign_key: :scorecard_uuid
  has_many   :custom_indicators, foreign_key: :scorecard_uuid

  validates :name, presence: true
  validates :province_id, presence: true
  validates :unit_type_id, presence: true
  validates :category_id, presence: true
  validates :scorecard_type_id, presence: true

  before_create :secure_uuid

  private
    def secure_uuid
      self.uuid ||= SecureRandom.hex(3)

      return unless self.class.exists?(uuid: uuid)

      self.uuid = SecureRandom.hex(4)
      secure_uuid
    end
end
