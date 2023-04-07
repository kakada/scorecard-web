# frozen_string_literal: true

# == Schema Information
#
# Table name: caf_batches
#
#  id             :uuid             not null, primary key
#  code           :string
#  total_count    :integer          default(0)
#  valid_count    :integer          default(0)
#  new_count      :integer          default(0)
#  province_count :integer          default(0)
#  user_id        :integer
#  reference      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe CafBatch, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:importing_cafs) }
  it { is_expected.to have_many(:cafs).through(:importing_cafs) }
end
