# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                    :bigint           not null, primary key
#  uuid                  :string
#  conducted_year        :datetime
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
require "rails_helper"

RSpec.describe Scorecard, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
