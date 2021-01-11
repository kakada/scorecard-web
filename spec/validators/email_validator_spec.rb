# frozen_string_literal: true

require "rails_helper"

class EmailValidatable
  include ActiveModel::Validations
  attr_accessor :value

  validates :value, email: true
end

RSpec.describe EmailValidator do
  subject { EmailValidatable.new }

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
      allow(subject).to receive(:value).and_return("abc@gmail.com")
    end

    it { expect(subject).to be_valid }
  end
end
