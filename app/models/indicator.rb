# frozen_string_literal: true

# == Schema Information
#
# Table name: indicators
#
#  id                 :bigint           not null, primary key
#  categorizable_id   :integer
#  categorizable_type :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tag_id             :integer
#  display_order      :integer
#  image              :string
#
class Indicator < ApplicationRecord
  include Indicatorable
  include Tagable

  belongs_to :categorizable, polymorphic: true, touch: true
  has_many :languages_indicators, dependent: :destroy
  has_many :languages, through: :languages_indicators

  validates :name, presence: true, uniqueness: { scope: [:categorizable_id, :categorizable_type] }
  validate :image_size_validation

  before_create :set_display_order

  default_scope { order(display_order: :asc) }

  # Nested Attributes
  accepts_nested_attributes_for :languages_indicators, allow_destroy: true, reject_if: lambda { |attributes|
    attributes["audio"] = nil if attributes["remove_audio"] == "1"
    return attributes["id"].blank? && attributes["content"].blank? && attributes["audio"].blank?
  }

  # Uploader
  mount_uploader :image, ImageUploader

  def image_or_default
    image_url || "default_image.png"
  end

  def editable_tag?
    raised_indicators.blank?
  end

  # Class methods
  def self.filter(params)
    scope = all
    scope = scope.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%") if params[:name].present?
    scope = scope.where(categorizable_id: params[:facility_id], categorizable_type: "Facility") if params[:facility_id].present?
    scope
  end

  private
    def set_display_order
      self.display_order ||= categorizable.present? && categorizable.indicators.maximum(:display_order).to_i + 1
    end

    def image_size_validation
      errors[:image] << I18n.t("indicator.must_be_less_than_1mb") if image.size > 1.megabytes
    end
end
