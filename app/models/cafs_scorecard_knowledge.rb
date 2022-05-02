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
class CafsScorecardKnowledge < ApplicationRecord
  belongs_to :caf
  belongs_to :scorecard_knowledge
end
