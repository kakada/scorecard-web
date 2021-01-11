# frozen_string_literal: true

# == Schema Information
#
# Table name: rating_scales
#
#  id         :bigint           not null, primary key
#  code       :string
#  value      :string
#  name       :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class RatingScaleSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :value

  has_many :language_rating_scales

  class LanguageRatingScaleSerializer < ActiveModel::Serializer
    attributes :id, :language_code, :audio, :content

    def audio
      object.audio_url
    end
  end
end
