# frozen_string_literal: true

# == Schema Information
#
# Table name: raised_people
#
#  id             :bigint           not null, primary key
#  scorecard_uuid :string
#  gender         :string
#  age            :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class RaisedPerson < ApplicationRecord
  belongs_to :scorecard, foreign_key: :scorecard_uuid
end
