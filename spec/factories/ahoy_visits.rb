# frozen_string_literal: true

# == Schema Information
#
# Table name: ahoy_visits
#
#  id               :bigint           not null, primary key
#  visit_token      :string
#  visitor_token    :string
#  user_id          :bigint
#  ip               :string
#  user_agent       :text
#  referrer         :text
#  referring_domain :string
#  landing_page     :text
#  browser          :string
#  os               :string
#  device_type      :string
#  country          :string
#  region           :string
#  city             :string
#  latitude         :float
#  longitude        :float
#  utm_source       :string
#  utm_medium       :string
#  utm_term         :string
#  utm_content      :string
#  utm_campaign     :string
#  app_version      :string
#  os_version       :string
#  platform         :string
#  started_at       :datetime
#
# spec/factories/ahoy_visits.rb
FactoryBot.define do
  factory :ahoy_visit, class: "Ahoy::Visit" do
    visit_token { SecureRandom.uuid }
    visitor_token { SecureRandom.uuid }
    platform { "web" }
    started_at { Time.current }
  end
end
