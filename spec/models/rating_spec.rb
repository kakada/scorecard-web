# frozen_string_literal: true

# == Schema Information
#
# Table name: ratings
#
#  scorecard_uuid        :string
#  score                 :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  uuid                  :string           default("uuid_generate_v4()"), not null, primary key
#  voting_indicator_uuid :string
#  participant_uuid      :string
#
require "rails_helper"

RSpec.describe Rating, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
