# frozen_string_literal: true

# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint           not null, primary key
#  visit_id   :bigint
#  user_id    :bigint
#  name       :string
#  properties :jsonb
#  time       :datetime
#
# spec/factories/ahoy_events.rb
FactoryBot.define do
  factory :ahoy_event, class: "Ahoy::Event" do
    visit { association :ahoy_visit }
    name { "view_fam_reporting" }
    time { Time.current }
    properties { {} }
  end
end
