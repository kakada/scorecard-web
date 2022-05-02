# frozen_string_literal: true

# == Schema Information
#
# Table name: cafs_scorecard_knowledges
#
#  id                     :bigint           not null, primary key
#  caf_id                 :integer
#  scorecard_knowledge_id :uuid
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :cafs_scorecard_knowledge do
  end
end
