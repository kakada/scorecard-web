# frozen_string_literal: true

# == Schema Information
#
# Table name: mobile_tokens
#
#  id          :bigint           not null, primary key
#  token       :string
#  program_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  device_id   :string
#  device_type :integer
#  app_version :string
#
class MobileToken < ApplicationRecord
  validates :token, presence: true

  enum device_type: {
    mobile: 1,
    tablet: 2,
    unknown: 3
  }

  def self.filter(params = {})
    scope = all
    scope = scope.where(app_version: params[:app_versions]) if params[:app_versions].present?
    scope
  end
end
