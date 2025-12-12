# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  datetime_format           :string           default("DD-MM-YYYY")
#  enable_email_notification :boolean          default(FALSE)
#  shortcut_name             :string
#  dashboard_user_emails     :text             default([]), is an Array
#  dashboard_user_roles      :string           default([]), is an Array
#  uuid                      :string
#
class Program < ApplicationRecord
  include Programs::Elasticsearch
  attr_accessor :skip_callback

  has_many :users
  has_many :languages
  has_many :facilities
  has_many :indicators, through: :facilities
  has_many :templates
  has_many :local_ngos
  has_many :cafs, through: :local_ngos
  has_many :scorecards
  has_many :rating_scales
  has_many :contacts
  has_many :pdf_templates
  has_many :chat_groups
  has_many :messages
  has_many :mobile_tokens
  has_many :activity_logs
  has_one  :data_publication, dependent: :destroy
  has_many :data_publication_logs, dependent: :destroy
  has_one  :telegram_bot, dependent: :destroy
  has_one  :gf_dashboard
  has_many :scorecard_batches
  has_many :program_scorecard_types
  has_many :removing_scorecard_batches
  has_many :local_ngo_batches
  has_many :program_clones, foreign_key: :target_program_id, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :shortcut_name, presence: true, uniqueness: true

  before_create :secure_uuid
  after_create :create_default_language
  after_create :create_default_rating_scale, unless: :skip_callback
  after_create :create_dashboard_async, unless: :skip_callback

  DATETIME_FORMATS = {
    "YYYY-MM-DD" => "%Y-%m-%d",
    "DD-MM-YYYY" => "%d-%m-%Y"
  }

  accepts_nested_attributes_for :rating_scales, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :telegram_bot, allow_destroy: true
  accepts_nested_attributes_for :data_publication, allow_destroy: true
  accepts_nested_attributes_for :program_scorecard_types, allow_destroy: true

  delegate :enabled, to: :telegram_bot, prefix: :telegram_bot, allow_nil: true

  def create_dashboard
    ::Dashboard.new(self).create
  end

  def update_dashboard
    ::Dashboard.new(self).update
  end

  def secure_uuid
    self.uuid ||= SecureRandom.uuid[0..7]

    return uuid unless self.class.exists?(uuid: uuid)

    self.uuid = SecureRandom.uuid[0..7]
    secure_uuid
  end

  def create_program_scorecard_types
    ProgramScorecardType::TYPES.each do |ty|
      scorecard_type = program_scorecard_types.find_or_initialize_by(code: ty[:code])
      scorecard_type.update(ty)
    end
  end

  def dataset_categories
    @dataset_categories ||= Category.where(id: facilities.pluck(:category_id))
  end

  private
    def create_default_language
      languages.create(code: "km", name_en: "Khmer", name_km: "ខ្មែរ")
    end

    def create_default_rating_scale
      rating_scales.create_defaults(languages.first)
    end

    def create_dashboard_async
      DashboardWorker.perform_async(id)
    end
end
