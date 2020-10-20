# frozen_string_literal: true

# == Schema Information
#
# Table name: local_ngos
#
#  id          :bigint           not null, primary key
#  name        :string
#  province_id :string(2)
#  district_id :string(4)
#  commune_id  :string(6)
#  village_id  :string(8)
#  address     :string
#  program_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe LocalNgo, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to have_many(:cafs) }
  it { is_expected.to have_many(:scorecards) }
  it { is_expected.to validate_presence_of(:name) }
end
