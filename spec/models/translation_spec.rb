# frozen_string_literal: true

# == Schema Information
#
# Table name: translations
#
#  id         :uuid             not null, primary key
#  key        :string           not null
#  locale     :string           not null
#  label      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# spec/models/translation_spec.rb

require "rails_helper"

RSpec.describe Translation, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:locale) }
    it { is_expected.to validate_presence_of(:label) }
  end

  describe ".lookup" do
    let!(:translation) do
      create(
        :translation,
        key: "title1",
        locale: "km",
        label: "ចំណងជើង១"
      )
    end

    context "when the translation exists" do
      it "returns the translated label" do
        expect(described_class.lookup("title1", "km"))
          .to eq("ចំណងជើង១")
      end
    end

    context "when the translation does not exist" do
      it "returns nil" do
        expect(described_class.lookup("title2", "km")).to be_nil
      end
    end

    context "when the key exists in another locale" do
      it "returns nil" do
        expect(described_class.lookup("title1", "en")).to be_nil
      end
    end
  end
end
