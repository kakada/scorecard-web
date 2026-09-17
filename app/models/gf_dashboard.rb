# frozen_string_literal: true

# == Schema Information
#
# Table name: gf_dashboards
#
#  id            :uuid             not null, primary key
#  dashboard_id  :integer
#  dashboard_uid :string
#  dashboard_url :string
#  org_id        :integer
#  org_token     :string
#  program_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  locale        :string           default("km"), not null
#
class GfDashboard < ApplicationRecord
  belongs_to :program

  LOCALES = %w(km en)
  LOCALE_NAMES = { "km" => "ខ្មែរ", "en" => "English" }.freeze

  validates :locale, presence: true, inclusion: { in: LOCALES }, uniqueness: { scope: :program_id }
end
