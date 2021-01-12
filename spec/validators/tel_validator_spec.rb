# frozen_string_literal: true

require "rails_helper"

class TelValidatable
  include ActiveModel::Validations
  attr_accessor :value

  validates :value, tel: true
end

RSpec.describe TelValidator do
  subject { TelValidatable.new }

  context "without value" do
    it { expect(subject).not_to be_valid }
  end

  context "with invalid value" do
    before do
      allow(subject).to receive(:value).and_return("invalid")
    end

    it { expect(subject).not_to be_valid }
  end

  context "with valid value" do
    before do
      allow(subject).to receive(:value).and_return("010222333")
    end

    it { expect(subject).to be_valid }
  end
end
