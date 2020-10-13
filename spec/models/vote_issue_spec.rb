# frozen_string_literal: true

# == Schema Information
#
# Table name: vote_issues
#
#  id             :bigint           not null, primary key
#  scorecard_uuid :string
#  content        :string
#  audio          :string
#  display_order  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe VoteIssue, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
