# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_indicators
#
#  id             :bigint           not null, primary key
#  name           :string
#  audio          :string
#  scorecard_uuid :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tag_id         :integer
#  uuid           :string
#
require "rails_helper"

RSpec.describe CustomIndicator, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
