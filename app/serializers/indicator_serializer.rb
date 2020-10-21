# == Schema Information
#
# Table name: indicators
#
#  id                 :bigint           not null, primary key
#  categorizable_id   :integer
#  categorizable_type :string
#  tag                :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class IndicatorSerializer < ActiveModel::Serializer
  attributes :id, :name, :tag

  belongs_to :categorizable
  has_many :languages_indicators

  class LanguagesIndicatorSerializer < ActiveModel::Serializer
    attributes :id, :language_code, :content, :audio

    def audio
      object.audio_url
    end
  end
end
