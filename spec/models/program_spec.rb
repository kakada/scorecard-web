# frozen_string_literal: true

require "rails_helper"

RSpec.describe Program, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:languages) }

  describe '#after_create' do
    let!(:program) { create(:program) }

    it { expect(program.languages.length).to eq(1) }
  end
end
