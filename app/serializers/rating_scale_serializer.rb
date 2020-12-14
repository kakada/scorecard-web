class RatingScaleSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :value

  has_many :language_rating_scales

  class LanguageRatingScaleSerializer < ActiveModel::Serializer
    attributes :id, :language_code, :audio

    def audio
      object.audio_url
    end
  end
end
