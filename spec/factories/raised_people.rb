# frozen_string_literal: true

# == Schema Information
#
# Table name: raised_people
#
#  id              :bigint           not null, primary key
#  scorecard_uuid  :string
#  gender          :string
#  age             :integer
#  disability      :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ethnic_minority :boolean
#  id_poor         :boolean
#
FactoryBot.define do
  factory :raised_person do
  end
end
