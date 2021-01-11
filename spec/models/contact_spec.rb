# frozen_string_literal: true

# == Schema Information
#
# Table name: contacts
#
#  id           :bigint           not null, primary key
#  contact_type :integer
#  value        :string
#  program_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "rails_helper"

RSpec.describe Contact, type: :model do
  it { is_expected.to belong_to(:program) }

  it { is_expected.to validate_presence_of(:contact_type) }
  it { is_expected.to validate_presence_of(:value) }
end
