# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ratings::MedianCalculator do
  describe "#call" do
    it "returns nil for empty scores" do
      expect(described_class.new([]).call).to be_nil
    end

    it "returns nil for nil input" do
      expect(described_class.new(nil).call).to be_nil
    end

    it "calculates median for odd number of scores" do
      expect(described_class.new([1, 3, 5]).call).to eq(3.0)
    end

    it "calculates median for even number of scores" do
      expect(described_class.new([1, 2, 3, 4]).call).to eq(2.5)
    end

    it "handles unsorted input" do
      expect(described_class.new([5, 1, 3]).call).to eq(3.0)
    end

    it "compacts nil values before calculation" do
      expect(described_class.new([nil, 2, nil, 4]).call).to eq(3.0)
    end

    it "converts string values to floats" do
      expect(described_class.new(["1", "3", "2"]).call).to eq(2.0)
    end

    it "handles single element arrays" do
      expect(described_class.new([7]).call).to eq(7.0)
    end

    it "handles negative numbers" do
      expect(described_class.new([-1, -2, -3]).call).to eq(-2.0)
    end

    it "accepts a non-array single value" do
      expect(described_class.new(5).call).to eq(5.0)
    end
  end
end
