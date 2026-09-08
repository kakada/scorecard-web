# frozen_string_literal: true

# == Schema Information
#
# Table name: translations
#
#  id         :uuid             not null, primary key
#  key        :string           not null
#  locale     :string           not null
#  label      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :translation do
    key { "hello" }
    locale { "en" }
    label { "Hello" }
  end
end
