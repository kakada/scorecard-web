# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  name           :string
#  parent_id      :integer
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  program_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :category do
  end
end
