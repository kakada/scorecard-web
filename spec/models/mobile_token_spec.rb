# frozen_string_literal: true

# == Schema Information
#
# Table name: mobile_tokens
#
#  id          :bigint           not null, primary key
#  token       :string
#  program_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  device_id   :string
#  device_type :integer
#  app_version :string
#
require "rails_helper"

RSpec.describe MobileToken, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
