# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Program, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:languages) }
  it { is_expected.to have_many(:categories) }
  it { is_expected.to have_many(:cafs) }
  it { is_expected.to validate_presence_of(:name) }

  describe "#after_create" do
    let!(:program) { create(:program) }

    it { expect(program.languages.length).to eq(1) }
  end
end
