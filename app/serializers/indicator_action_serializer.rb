# frozen_string_literal: true

# == Schema Information
#
# Table name: indicator_actions
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  predefined     :boolean          default(TRUE)
#  kind           :integer
#  indicator_uuid :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class IndicatorActionSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :kind, :predefined, :indicator_uuid
end
