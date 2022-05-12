# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_knowledges
#
#  id               :uuid             not null, primary key
#  code             :string
#  name_en          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  name_km          :string
#  shortcut_name_en :string
#  shortcut_name_km :string
#
FactoryBot.define do
  factory :scorecard_knowledge do
  end
end
