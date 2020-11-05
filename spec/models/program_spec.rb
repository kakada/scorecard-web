# frozen_string_literal: true

# == Schema Information
#
# Table name: programs
#
#  id              :bigint           not null, primary key
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  datetime_format :string           default("YYYY-MM-DD")
#
require "rails_helper"

RSpec.describe Program, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:languages) }
  it { is_expected.to have_many(:facilities) }
  it { is_expected.to have_many(:local_ngos) }
  it { is_expected.to have_many(:scorecard_types) }
  it { is_expected.to validate_presence_of(:name) }

  describe "#after_create" do
    let!(:program) { create(:program) }

    it { expect(program.languages.length).to eq(1) }
  end
end
