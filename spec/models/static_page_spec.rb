# frozen_string_literal: true

# == Schema Information
#
# Table name: static_pages
#
#  id         :uuid             not null, primary key
#  slug       :string           not null
#  content_en :text
#  content_km :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe StaticPage, type: :model do
  subject { build(:static_page) }

  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_uniqueness_of(:slug) }

  describe "#event_name" do
    it "prefixes the slug with view_" do
      static_page = build(:static_page, slug: "privacy_policy")

      expect(static_page.event_name).to eq("view_privacy_policy")
    end
  end

  describe "#url" do
    it "prefixes the slug with a leading slash" do
      static_page = build(:static_page, slug: "privacy_policy")

      expect(static_page.url).to eq("/privacy_policy")
    end
  end

  describe "#content_by_locale" do
    it "returns khmer content for km locale" do
      static_page = build(:static_page, content_km: "<p>km</p>", content_en: "<p>en</p>")

      expect(static_page.content_by_locale(:km)).to eq("<p>km</p>")
    end

    it "falls back to english content when km is blank" do
      static_page = build(:static_page, content_km: nil, content_en: "<p>en</p>")

      expect(static_page.content_by_locale(:km)).to eq("<p>en</p>")
    end
  end

  describe "#rendered_content_by_locale" do
    let!(:static_page_variable) { create(:static_page_variable, key: "QR_CODE", value: "Rendered QR code") }

    it "interpolates stored variables into localized content" do
      static_page = build(:static_page, content_km: "<p>{{QR_CODE}}</p>", content_en: "<p>en</p>")

      expect(static_page.rendered_content_by_locale(:km)).to eq("<p>Rendered QR code</p>")
    end

    it "leaves unknown variables untouched" do
      static_page = build(:static_page, content_en: "<p>{{UNKNOWN_CODE}}</p>")

      expect(static_page.rendered_content_by_locale(:en)).to eq("<p>{{UNKNOWN_CODE}}</p>")
    end

    it "keeps text variable HTML escaped after interpolation" do
      static_page_variable.update!(value: "<strong>unsafe</strong>")
      static_page = build(:static_page, content_en: "<p>{{QR_CODE}}</p>")

      expect(static_page.rendered_content_by_locale(:en)).to eq("<p>&lt;strong&gt;unsafe&lt;/strong&gt;</p>")
    end
  end
end
