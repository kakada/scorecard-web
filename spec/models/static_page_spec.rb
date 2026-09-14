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
end
