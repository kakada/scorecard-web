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
  belongs_to :program
  has_many :language_rating_scales

  accepts_nested_attributes_for :language_rating_scales, allow_destroy: true, reject_if: lambda { |attributes|
    attributes["audio"] = nil if attributes["remove_audio"] == "1"

    return attributes["id"].blank? && attributes["audio"].blank?
  }

  def self.defaults
    [
      { code: "very_bad", value: "1", name: "Very bad" },
      { code: "bad", value: "2", name: "Bad" },
      { code: "acceptable", value: "3", name: "Acceptable" },
      { code: "good", value: "4", name: "Good" },
      { code: "very_good", value: "5", name: "Very good" }
    ]
  end
end
