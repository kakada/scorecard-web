# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_indicators
#
#  id             :bigint           not null, primary key
#  name           :string
#  audio          :string
#  tag_id         :integer
#  scorecard_uuid :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class CustomIndicator < ApplicationRecord
  include Indicatorable
  include Tagable

  mount_uploader :audio, AudioUploader

  belongs_to :scorecard, foreign_key: :scorecard_uuid
end
