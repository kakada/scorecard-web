# frozen_string_literal: true

# == Schema Information
#
# Table name: static_page_variables
#
#  id            :uuid             not null, primary key
#  key           :string           not null
#  variable_type :integer          default("text"), not null
#  value         :text
#  image         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class StaticPageVariable < ApplicationRecord
  mount_uploader :image, ImageUploader

  enum variable_type: { text: 0, image: 1, url: 2 }

  validates :key, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[A-Z0-9_]+\z/ }
  validates :variable_type, presence: true
  validates :value, presence: true, unless: :image?
  validates :value, url: true, if: -> { url? && value.present? }
  validates :image, presence: true, if: :image?

  scope :ordered, -> { order(:key) }

  before_validation :normalize_key

  def token
    "{{#{key}}}"
  end

  def rendered_value
    return helpers.image_tag(image.url, alt: key) if image? && image.present?
    return helpers.link_to(value, value, target: "_blank", rel: "noopener noreferrer") if url?

    ERB::Util.html_escape(value)
  end

  private
    def normalize_key
      self.key = key.to_s.upcase
    end

    def helpers
      ActionController::Base.helpers
    end
end
