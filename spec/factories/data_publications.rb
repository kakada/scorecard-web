# frozen_string_literal: true

# == Schema Information
#
# Table name: data_publications
#
#  id               :uuid             not null, primary key
#  program_id       :integer
#  published_option :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :data_publication do
    published_option { DatePublication.published_options.to_a.sample.first }
    program
  end
end
