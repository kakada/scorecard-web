# frozen_string_literal: true

# == Schema Information
#
# Table name: rating_scales
#
#  id         :bigint           not null, primary key
#  value      :string
#  name       :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  code       :string
#
class RatingScale < ApplicationRecord
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid
  has_many :language_rating_scales, dependent: :destroy

  accepts_nested_attributes_for :language_rating_scales, allow_destroy: true, reject_if: lambda { |attributes|
    attributes["audio"] = nil if attributes["remove_audio"] == "1"

    return attributes["id"].blank? && attributes["content"].blank? && attributes["audio"].blank?
  }

  def self.defaults
    [
      { code: "very_bad", value: "1", name: "Very bad", language_rating_scales_attributes: [{ content: "មិនពេញចិត្តខ្លាំង", audio: "very_bad.mp3" }] },
      { code: "bad", value: "2", name: "Bad", language_rating_scales_attributes: [{ content: "មិនពេញចិត្ត", audio: "bad.mp3" }] },
      { code: "acceptable", value: "3", name: "Acceptable", language_rating_scales_attributes: [{ content: "ទទួលយកបាន", audio: "acceptable.mp3" }] },
      { code: "good", value: "4", name: "Good", language_rating_scales_attributes: [{ content: "ពេញចិត្ត", audio: "good.mp3" }] },
      { code: "very_good", value: "5", name: "Very good", language_rating_scales_attributes: [{ content: "ពេញចិត្តខ្លាំង", audio: "very_good.mp3" }] },
    ]
  end

  def self.create_defaults(km_language)
    defaults.each do |rating|
      rating[:language_rating_scales_attributes].each do |lang_rating|
        lang_rating[:language_id] = km_language.id
        lang_rating[:language_code] = km_language.code
        lang_rating[:audio] = Pathname.new(Dir.glob(Rails.root.join("lib", "assets", "audios", "**")).select { |file| file.split("/").last == "#{lang_rating[:audio]}" }.first).open
      end

      self.create(rating)
    end
  end
end
