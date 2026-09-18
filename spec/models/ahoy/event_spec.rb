# frozen_string_literal: true

# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint           not null, primary key
#  visit_id   :bigint
#  user_id    :bigint
#  name       :string
#  properties :jsonb
#  time       :datetime
#
require "rails_helper"

RSpec.describe Ahoy::Event, type: :model do
  describe ".filter" do
    let!(:fam_reporting_event) { create(:ahoy_event, name: "view_fam_reporting", time: 2.days.ago) }
    let!(:privacy_policy_event) { create(:ahoy_event, name: "view_privacy_policy", time: Time.current) }

    it "returns all events when no filters are given" do
      expect(described_class.filter({})).to contain_exactly(fam_reporting_event, privacy_policy_event)
    end

    it "filters by a single event name" do
      result = described_class.filter(name: "view_fam_reporting")

      expect(result).to contain_exactly(fam_reporting_event)
    end

    it "filters by multiple event names" do
      result = described_class.filter(name: ["view_fam_reporting", "view_privacy_policy"])

      expect(result).to contain_exactly(fam_reporting_event, privacy_policy_event)
    end

    it "filters by start_time" do
      result = described_class.filter(start_time: 1.day.ago)

      expect(result).to contain_exactly(privacy_policy_event)
    end

    it "filters by end_time" do
      result = described_class.filter(end_time: 1.day.ago)

      expect(result).to contain_exactly(fam_reporting_event)
    end

    it "combines name and time filters" do
      result = described_class.filter(name: "view_fam_reporting", start_time: 1.day.ago)

      expect(result).to be_empty
    end
  end
end
