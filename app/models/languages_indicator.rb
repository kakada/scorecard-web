# frozen_string_literal: true

# == Schema Information
#
# Table name: languages_indicators
#
#  id            :bigint           not null, primary key
#  language_id   :integer
#  language_code :string
#  indicator_id  :integer
#  content       :string
#  audio         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  version       :integer          default(0)
#
class LanguagesIndicator < ApplicationRecord
  belongs_to :language
  belongs_to :indicator, touch: true

  mount_uploader :audio, AudioUploader

  validates :content, presence: true

  before_update :increase_version

  private
    def increase_version
      self.version = version + 1
    end
end
