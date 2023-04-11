# frozen_string_literal: true

# == Schema Information
#
# Table name: local_ngo_batches
#
#  id          :uuid             not null, primary key
#  code        :string
#  total_count :integer          default(0)
#  valid_count :integer          default(0)
#  reference   :string
#  user_id     :integer
#  program_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe LocalNgoBatch, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:local_ngos) }
end
