# frozen_string_literal: true

FactoryBot.define do
  factory :fam_reporting_stat do
    source { :web }
    views_count { 1 }
  end
end
