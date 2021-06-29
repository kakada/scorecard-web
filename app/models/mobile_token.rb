# frozen_string_literal: true

# == Schema Information
#
# Table name: mobile_tokens
#
#  id         :bigint           not null, primary key
#  token      :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class MobileToken < ApplicationRecord
  validates :token, presence: true
end
