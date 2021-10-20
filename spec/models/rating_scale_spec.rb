# frozen_string_literal: true

# == Schema Information
#
# Table name: rating_scales
#
#  id         :bigint           not null, primary key
#  code       :string
#  value      :string
#  name       :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe RatingScale, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to have_many(:language_rating_scales).dependent(:destroy) }
end
