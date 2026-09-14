# frozen_string_literal: true

# == Schema Information
#
# Table name: static_page_variables
#
#  id            :uuid             not null, primary key
#  key           :string           not null
#  variable_type :integer          default("text"), not null
#  value         :text
#  image         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe StaticPageVariable, type: :model do
  subject { build(:static_page_variable) }

  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_uniqueness_of(:key).case_insensitive }
  it { is_expected.to define_enum_for(:variable_type).with_values(text: 0, image: 1, url: 2) }

  describe "#token" do
    it "normalizes keys and returns a token" do
      variable = build(:static_page_variable, key: "qr_code")
      variable.valid?

      expect(variable.key).to eq("QR_CODE")
      expect(variable.token).to eq("{{QR_CODE}}")
    end
  end

  describe "#rendered_value" do
    it "escapes text values" do
      variable = build(:static_page_variable, value: "<script>alert(1)</script>")

      expect(variable.rendered_value).to eq("&lt;script&gt;alert(1)&lt;/script&gt;")
    end

    it "renders a link for url values" do
      variable = build(:static_page_variable, :url)

      expect(variable.rendered_value).to include(%(href="https://example.com"))
    end

    it "renders an image tag for image values" do
      variable = create(:static_page_variable, :image, key: "QR_CODE")

      expect(variable.rendered_value).to include("<img")
      expect(variable.rendered_value).to include(variable.image.url)
    end
  end
end
