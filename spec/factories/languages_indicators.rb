# frozen_string_literal: true

# == Schema Information
#
# Table name: languages_indicators
#
#  id            :bigint           not null, primary key
#  language_id   :integer
#  language_code :string
#  indicator_id  :integer
#  content       :string
#  audio         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :languages_indicator do
    language
    language_code { language.code}
    content       { FFaker::Name.name }
    indicator
  end
end
