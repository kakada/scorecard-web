# frozen_string_literal: true

# == Schema Information
#
# Table name: pdf_templates
#
#  id            :bigint           not null, primary key
#  name          :string
#  content       :text
#  language_code :string
#  program_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :pdf_template do
    name { FFaker::Name.name }
    language_code { "km" }
    program
  end
end
