# frozen_string_literal: true

# == Schema Information
#
# Table name: telegram_bots
#
#  id         :bigint           not null, primary key
#  token      :string
#  username   :string
#  enabled    :boolean          default(FALSE)
#  actived    :boolean          default(FALSE)
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe TelegramBot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
