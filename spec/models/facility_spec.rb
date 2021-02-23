# frozen_string_literal: true

# == Schema Information
#
# Table name: facilities
#
#  id             :bigint           not null, primary key
#  code           :string
#  name           :string
#  parent_id      :integer
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  program_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  subset         :string
#
require "rails_helper"

RSpec.describe Facility, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to validate_presence_of(:name) }
end
