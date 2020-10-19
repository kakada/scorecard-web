class CustomIndicator < ApplicationRecord
  belongs_to :scorecard, foreign_key: :scorecard_uuid

  mount_uploader :audio, AudioUploader
end
