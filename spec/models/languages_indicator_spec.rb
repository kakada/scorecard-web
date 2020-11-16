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
  include CarrierWave::Test::Matchers

  it { is_expected.to belong_to(:language) }
  it { is_expected.to belong_to(:indicator).touch(true) }
  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_presence_of(:audio) }

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

  it "should touch the indicator" do
    languages_indicator = build(:languages_indicator)
    languages_indicator.indicator.should_receive(:touch)
    languages_indicator.save!
  end

  describe "validate file format" do
    let(:languages_indicator) { create(:languages_indicator) }
    let(:uploader) { AudioUploader.new(languages_indicator, :audio) }

    before do
      AudioUploader.enable_processing = true
      File.open(Rails.root.join("spec", "fixtures", "files", "audio.mp3")) { |f| uploader.store!(f) }
    end

    after do
      AudioUploader.enable_processing = false
      uploader.remove!
    end

    it { expect(uploader.extension_whitelist).to include("mp3") }
  end

  describe "validate file size" do
    let(:big_file) { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", "big_audio.mp3")) }
    let(:languages_indicator) { build(:languages_indicator, audio: big_file) }

    it { expect(languages_indicator.valid?).to be_falsey }

    it "return validate file size message" do
      languages_indicator.valid?
      expect(languages_indicator.errors[:audio]).to eq ["should be less than 2MB"]
    end
  end
end
