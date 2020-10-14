# frozen_string_literal: true

# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  json_file  :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :language do
    code  { FFaker::Locale.code }
    name  { FFaker::Locale.language }
    program
  end
end
