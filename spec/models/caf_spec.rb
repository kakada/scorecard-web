# == Schema Information
#
# Table name: cafs
#
#  id          :bigint           not null, primary key
#  name        :string
#  province_id :string(2)
#  district_id :string(4)
#  commune_id  :string(6)
#  address     :string
#  program_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Caf, type: :model do
  it { is_expected.to belong_to(:local_ngo) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to validate_presence_of(:name) }
end
