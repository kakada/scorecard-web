# frozen_string_literal: true

# == Schema Information
#
# Table name: jaaps
#
#  id                :bigint           not null, primary key
#  title             :string
#  description       :text
#  uuid              :string           not null
#  program_id        :bigint
#  scorecard_id      :string
#  user_id           :bigint
#  field_definitions :jsonb            default([])
#  rows_data         :jsonb            default([])
#  completed_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "rails_helper"

RSpec.describe Jaap, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:program) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:scorecard).optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:uuid) }
    it { is_expected.to validate_presence_of(:field_definitions) }
  end

  describe "callbacks" do
    context "when creating a new JAAP" do
      it "generates a UUID" do
        jaap = build(:jaap, uuid: nil)
        jaap.save
        expect(jaap.uuid).to be_present
      end
    end
  end

  describe ".default_field_definitions" do
    it "returns the default field definitions" do
      expect(Jaap.default_field_definitions).to be_an(Array)
      expect(Jaap.default_field_definitions).not_to be_empty
      expect(Jaap.default_field_definitions.first).to have_key(:key)
      expect(Jaap.default_field_definitions.first).to have_key(:label)
      expect(Jaap.default_field_definitions.first).to have_key(:type)
    end
  end

  describe "#completed?" do
    context "when completed_at is present" do
      it "returns true" do
        jaap = create(:jaap, :completed)
        expect(jaap.completed?).to be true
      end
    end

    context "when completed_at is nil" do
      it "returns false" do
        jaap = create(:jaap)
        expect(jaap.completed?).to be false
      end
    end
  end

  describe "#complete!" do
    it "sets completed_at to current time" do
      jaap = create(:jaap)
      expect(jaap.completed_at).to be_nil
      
      jaap.complete!
      expect(jaap.completed_at).to be_present
      expect(jaap.completed?).to be true
    end
  end

  describe "uuid uniqueness" do
    it "ensures unique uuid" do
      jaap1 = create(:jaap)
      jaap2 = build(:jaap, uuid: jaap1.uuid)
      
      expect(jaap2).not_to be_valid
      expect(jaap2.errors[:uuid]).to include("has already been taken")
    end
  end
end
