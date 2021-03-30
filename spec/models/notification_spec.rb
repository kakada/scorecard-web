# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  provider   :string
#  emails     :text             default([]), is an Array
#  message_id :integer
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Notification, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
