# frozen_string_literal: true

# == Schema Information
#
# Table name: indicators
#
#  id                 :bigint           not null, primary key
#  categorizable_id   :integer
#  categorizable_type :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tag_id             :integer
#  display_order      :integer
#  image              :string
#  uuid               :string
#  audio              :string
#  type               :string           default("Indicators::PredefineIndicator")
#  deleted_at         :datetime
#
class IndicatorSerializer < ActiveModel::Serializer
  attributes :id, :name, :tag_id, :tag_name, :image, :uuid

  belongs_to :categorizable
  has_many :languages_indicators
  has_many :indicator_actions do
    object.indicator_actions.predefineds
  end

  def tag_name
    object.tag_name
  end

  def image
    object.image_url
  end

  class LanguagesIndicatorSerializer < ActiveModel::Serializer
    attributes :id, :language_code, :content, :audio, :version

    def audio
      object.audio_url
    end
  end
end
