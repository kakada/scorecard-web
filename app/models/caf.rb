# frozen_string_literal: true

# == Schema Information
#
# Table name: cafs
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  sex                       :string
#  date_of_birth             :string
#  tel                       :string
#  address                   :string
#  local_ngo_id              :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  actived                   :boolean          default(TRUE)
#  educational_background_id :string
#  scorecard_knowledge_id    :string
#  deleted_at                :datetime
#  province_id               :string
#  district_id               :string
#  commune_id                :string
#  age                       :integer
#
class Caf < ApplicationRecord
  belongs_to :local_ngo
  belongs_to :educational_background, optional: true

  has_many :facilitators
  has_many :scorecards, through: :facilitators
  has_many :cafs_scorecard_knowledges
  has_many :scorecard_knowledges, through: :cafs_scorecard_knowledges

  has_many :importing_cafs
  has_many :caf_batches, through: :importing_cafs

  acts_as_paranoid if column_names.include? "deleted_at"

  delegate :name, to: :educational_background, prefix: :educational_background, allow_nil: true
  delegate :name, to: :scorecard_knowledge, prefix: :scorecard_knowledge, allow_nil: true

  GENDERS = %w(female male other)

  validates :name, presence: true
  validates :sex, inclusion: { in: GENDERS }, allow_blank: true
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 150 }, allow_blank: true
  validates :province_id, inclusion: { in: Pumi::Province.all.pluck(:id) }, allow_blank: true
  validates :district_id, inclusion: { in: Pumi::District.all.pluck(:id) }, allow_blank: true
  validates :commune_id, inclusion: { in: Pumi::Commune.all.pluck(:id) }, allow_blank: true

  scope :actives, -> { where(actived: true) }

  def self.filter(params)
    scope = all
    scope = scope.where("LOWER(name) LIKE ? OR tel LIKE ?", "%#{params[:keyword].downcase}%", "%#{params[:keyword].downcase}%") if params[:keyword].present?
    scope = scope.where(local_ngo_id: params[:local_ngo_id]) if params[:local_ngo_id].present?
    scope
  end

  def location_code
    commune_id || district_id || province_id
  end

  def based_location_name
    return if location_code.blank?

    klass = Location.location_kind(location_code)
    "Pumi::#{klass.capitalize}".constantize.find_by_id(location_code).try("address_#{I18n.locale}".to_sym)
  end
end
