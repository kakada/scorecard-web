# frozen_string_literal: true

# == Schema Information
#
# Table name: predefined_issues
#
#  id             :bigint           not null, primary key
#  scorecard_uuid :string
#  content        :text
#  audio          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe PredefinedIssue, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
