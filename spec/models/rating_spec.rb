# frozen_string_literal: true

# == Schema Information
#
# Table name: ratings
#
#  id                  :bigint           not null, primary key
#  voting_indicator_id :integer
#  voting_person_id    :integer
#  scorecard_uuid      :string
#  score               :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require "rails_helper"

RSpec.describe Rating, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
