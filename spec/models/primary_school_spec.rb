# frozen_string_literal: true

# == Schema Information
#
# Table name: primary_schools
#
#  id         :bigint           not null, primary key
#  code       :string
#  name_en    :string
#  name_km    :string
#  commune_id :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe PrimarySchool, type: :model do
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:name_km) }
  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:commune_id) }
end
