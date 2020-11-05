# frozen_string_literal: true

# == Schema Information
#
# Table name: cafs
#
#  id            :bigint           not null, primary key
#  name          :string
#  sex           :string
#  date_of_birth :string
#  tel           :string
#  address       :string
#  local_ngo_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe Caf, type: :model do
  it { is_expected.to belong_to(:local_ngo) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_inclusion_of(:sex).in_array(%w(female male other)).allow_nil }
end
