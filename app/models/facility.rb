# frozen_string_literal: true

# == Schema Information
#
# Table name: facilities
#
#  id             :bigint           not null, primary key
#  code           :string
#  name_en        :string
#  parent_id      :integer
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  program_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  dataset        :string
#  default        :boolean          default(FALSE)
#  name_km        :string
#
class Facility < ApplicationRecord
  include Categorizable

  attr_accessor :has_child

  acts_as_nested_set scope: [:program_uuid]

  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid
  has_many :unit_scorecards, foreign_key: :unit_type_id, class_name: "Scorecard"
  has_many :scorecards, foreign_key: :facility_id

  validates :name_en, presence: true
  validates :name_km, presence: true
  validates :code, presence: true
  validates :dataset, presence: true, if: -> { self.has_child }

  DATASETS = [
    { code: "ps", name_en: "Primary School", name_km: "បឋមសិក្សា", dataset: "PrimarySchool" }
  ]

  def has_child
    @has_child == "on" || dataset.present?
  end

  def name
    self["name_#{I18n.locale}"]
  end

  def locked?
    self.default? || self.unit_scorecards.present? || self.scorecards.present?
  end
end
