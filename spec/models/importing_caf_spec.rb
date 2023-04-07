# frozen_string_literal: true

# == Schema Information
#
# Table name: importing_cafs
#
#  id           :uuid             not null, primary key
#  caf_id       :integer
#  caf_batch_id :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "rails_helper"

RSpec.describe ImportingCaf, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
