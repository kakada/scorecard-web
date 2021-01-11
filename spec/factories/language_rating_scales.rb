# frozen_string_literal: true

# == Schema Information
#
# Table name: language_rating_scales
#
#  id              :bigint           not null, primary key
#  rating_scale_id :integer
#  language_id     :integer
#  language_code   :string
#  audio           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  content         :string
#
FactoryBot.define do
  factory :language_rating_scale do
    content       { RatingScale.defaults.sample[:name] }
    language
    language_code { language.code }
    rating_scale
    audio         { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", "audio.mp3")) }
  end
end
