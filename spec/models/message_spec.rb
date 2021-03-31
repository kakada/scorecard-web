# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  content    :text
#  milestone  :string
#  program_id :integer
#  actived    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Message, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
