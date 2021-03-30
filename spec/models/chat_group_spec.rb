# frozen_string_literal: true

# == Schema Information
#
# Table name: chat_groups
#
#  id         :bigint           not null, primary key
#  title      :string
#  chat_id    :string
#  actived    :boolean          default(TRUE)
#  reason     :text
#  provider   :string
#  program_id :integer
#  chat_type  :string           default("group")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe ChatGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
