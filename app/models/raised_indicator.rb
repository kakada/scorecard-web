# frozen_string_literal: true

# == Schema Information
#
# Table name: raised_indicators
#
#  id                 :bigint           not null, primary key
#  indicatorable_id   :integer
#  indicatorable_type :string
#  raised_person_id   :integer
#  scorecard_uuid     :string
#  tag_id             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class RaisedIndicator < ApplicationRecord
  include Tagable

  belongs_to :scorecard, foreign_key: :scorecard_uuid
  belongs_to :indicatorable, polymorphic: true
end
