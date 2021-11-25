# frozen_string_literal: true

module Audio
  extend ActiveSupport::Concern

  included do
    mount_uploader :audio, AudioUploader

    validates :audio, presence: true
    validate :audio_size_validation

    private
      def audio_size_validation
        errors.add(:audio, I18n.t("indicator.must_be_less_than_2mb")) if audio.size > 2.megabytes
      end
  end
end
