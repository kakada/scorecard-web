# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                    :bigint           not null, primary key
#  uuid                  :string
#  conducted_year        :integer
#  conducted_date        :datetime
#  province_code         :string(2)
#  district_code         :string(4)
#  commune_code          :string(6)
#  category              :integer
#  sector                :string
#  number_of_caf         :integer
#  number_of_participant :integer
#  number_of_female      :integer
#  caf_members           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class Scorecard < ApplicationRecord
  has_many :raised_people, foreign_key: :scorecard_uuid
  has_many :raised_issues, foreign_key: :scorecard_uuid
  has_many :predefined_issues, foreign_key: :scorecard_uuid
  has_many :vote_issues, foreign_key: :scorecard_uuid
  has_many :vote_people, foreign_key: :scorecard_uuid
  has_many :swots, foreign_key: :scorecard_uuid

  serialize :caf_members, Array

  enum category: {
    community: 1,
    self_accessment: 2
  }

  def location
    ::Pumi::Commune.find_by_id(commune_code).try(:address_km)
  end
end
