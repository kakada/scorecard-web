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
#
class Program < ApplicationRecord
  include Programs::Elasticsearch
  attr_accessor :skip_callback

  # self.primary_key = :uuid

  has_one  :gf_dashboard, primary_key: :uuid, foreign_key: :program_uuid, dependent: :destroy
  has_one  :telegram_bot, primary_key: :uuid, foreign_key: :program_uuid, dependent: :destroy
  has_many :users, primary_key: :uuid, foreign_key: :program_uuid
  has_many :languages, primary_key: :uuid, foreign_key: :program_uuid
  has_many :facilities, primary_key: :uuid, foreign_key: :program_uuid
  has_many :templates, primary_key: :uuid, foreign_key: :program_uuid
  has_many :local_ngos, primary_key: :uuid, foreign_key: :program_uuid
  has_many :scorecards, primary_key: :uuid, foreign_key: :program_uuid
  has_many :rating_scales, primary_key: :uuid, foreign_key: :program_uuid
  has_many :contacts, primary_key: :uuid, foreign_key: :program_uuid
  has_many :pdf_templates, primary_key: :uuid, foreign_key: :program_uuid
  has_many :chat_groups, primary_key: :uuid, foreign_key: :program_uuid
  has_many :messages, primary_key: :uuid, foreign_key: :program_uuid
  has_many :mobile_notifications, primary_key: :uuid, foreign_key: :program_uuid
  has_many :mobile_tokens, primary_key: :uuid, foreign_key: :program_uuid
  has_many :notifications, primary_key: :uuid, foreign_key: :program_uuid
  has_many :activity_logs, primary_key: :uuid, foreign_key: :program_uuid

  validates :name, presence: true, uniqueness: true
  validates :shortcut_name, presence: true, uniqueness: true

  before_save  :secure_uuid
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

  delegate :enabled, to: :telegram_bot, prefix: :telegram_bot, allow_nil: true

  def create_dashboard
    ::Dashboard.new(self).create
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
