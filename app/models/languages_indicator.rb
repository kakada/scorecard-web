class LanguagesIndicator < ApplicationRecord
  belongs_to :language
  belongs_to :indicator

  mount_uploader :audio, AudioUploader

  validates :content, presence: true
end
