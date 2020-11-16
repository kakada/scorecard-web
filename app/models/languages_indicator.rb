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
  validates :audio, presence: true
  validate :audio_size_validation

  before_update :increase_version

  private
    def increase_version
      self.version = version + 1
    end

    def audio_size_validation
      errors[:audio] << "should be less than 2MB" if audio.size > 2.megabytes
    end
end
