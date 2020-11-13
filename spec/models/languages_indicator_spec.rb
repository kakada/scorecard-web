# frozen_string_literal: true

# == Schema Information
#
# Table name: languages_indicators
#
#  id            :bigint           not null, primary key
#  language_id   :integer
#  language_code :string
#  indicator_id  :integer
#  content       :string
#  audio         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  version       :integer          default(0)
#
require "rails_helper"

RSpec.describe LanguagesIndicator, type: :model do
  it { is_expected.to belong_to(:language) }
  it { is_expected.to belong_to(:indicator) }
  it { is_expected.to validate_presence_of(:content) }

  describe "#after_create, version is 0" do
    let(:languages_indicator) { create(:languages_indicator) }

    it { expect(languages_indicator.version).to eq(0) }
  end

  describe "#before update, #increase_version" do
    let!(:languages_indicator) { create(:languages_indicator) }

    before {
      languages_indicator.update(content: "Working on time")
    }

    it { expect(languages_indicator.version).to eq(1) }
  end
end
