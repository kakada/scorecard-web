# == Schema Information
#
# Table name: scorecards_cafs
#
#  id           :bigint           not null, primary key
#  caf_id       :integer
#  scorecard_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe ScorecardsCaf, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
