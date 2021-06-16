# frozen_string_literal: true

# == Schema Information
#
# Table name: language_rating_scales
#
#  id              :bigint           not null, primary key
#  rating_scale_id :integer
#  language_id     :integer
#  language_code   :string
#  audio           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  content         :string
#
require "rails_helper"

RSpec.describe LanguageRatingScale, type: :model do
  include CarrierWave::Test::Matchers

  it { is_expected.to belong_to(:language) }
  it { is_expected.to belong_to(:rating_scale) }
  it { is_expected.to validate_presence_of(:audio) }
  it { is_expected.to validate_presence_of(:content) }

  describe "validate file format" do
    let(:language_rating_scale) { create(:language_rating_scale) }
    let(:uploader) { AudioUploader.new(language_rating_scale, :audio) }

    before do
      AudioUploader.enable_processing = true
      File.open(Rails.root.join("spec", "fixtures", "files", "audio.mp3")) { |f| uploader.store!(f) }
    end

    after do
      AudioUploader.enable_processing = false
      uploader.remove!
    end

    it { expect(uploader.extension_allowlist).to include("mp3") }
  end
end
