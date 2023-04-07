# frozen_string_literal: true

# == Schema Information
#
# Table name: importing_cafs
#
#  id           :uuid             not null, primary key
#  caf_id       :integer
#  caf_batch_id :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :importing_caf do
  end
end
